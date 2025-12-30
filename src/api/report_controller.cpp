#include "report_controller.h"
#include "../bus/report_service.h"
#include "../bus/session_manager.h"
#include <bsoncxx/types.hpp>
#include <chrono>
#include <string>

using std::string;

void ReportController::registerRoutes(crow::SimpleApp& app) {
    auto createReportHandler = [](const crow::request& req) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto body = crow::json::load(req.body);
        if (!body || !body.has("title") || !body.has("content") || !body.has("type")) {
            return crow::response(400, "Invalid payload");
        }

        auto result = ReportService::createReport(
            *username,
            body["title"].s(),
            body["content"].s(),
            body["type"].i()
        );

        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        return crow::response(201, "Report created");
    };

    auto listReportsHandler = [](const crow::request& req) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto reports = ReportService::getReportsForManagerRegion(*username);
        if (!reports.has_value()) {
            return crow::response(400, reports.error());
        }

        crow::json::wvalue response;
        crow::json::wvalue::list list;
        list.reserve(reports->size());

        for (const auto& doc : reports.value()) {
            auto view = doc.view();
            crow::json::wvalue item;

            if (auto idElement = view["_id"]; idElement && idElement.type() == bsoncxx::type::k_oid) {
                item["id"] = idElement.get_oid().value.to_string();
            }

            if (auto title = view["title"]; title && title.type() == bsoncxx::type::k_string) {
                item["title"] = std::string(title.get_string().value);
            } else {
                item["title"] = "";
            }

            if (auto content = view["content"]; content && content.type() == bsoncxx::type::k_string) {
                item["content"] = std::string(content.get_string().value);
            } else {
                item["content"] = "";
            }

            int typeValue = 0;
            if (auto typeElement = view["type"]; typeElement) {
                if (typeElement.type() == bsoncxx::type::k_int32) {
                    typeValue = typeElement.get_int32().value;
                } else if (typeElement.type() == bsoncxx::type::k_int64) {
                    typeValue = static_cast<int>(typeElement.get_int64().value);
                }
            }
            item["type"] = typeValue;

            bool resolved = false;
            if (auto resolvedElement = view["resolved"]; resolvedElement && resolvedElement.type() == bsoncxx::type::k_bool) {
                resolved = resolvedElement.get_bool().value;
            }
            item["resolved"] = resolved;

            long long createdAtMs = 0;
            if (auto createdAt = view["created_at"]; createdAt && createdAt.type() == bsoncxx::type::k_date) {
                auto raw = createdAt.get_date().value;
                auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(raw);
                createdAtMs = ms.count();
            }
            item["created_at"] = createdAtMs;

            list.emplace_back(std::move(item));
        }

        response["reports"] = crow::json::wvalue(list);
        return crow::response(response);
    };

    auto resolveReportHandler = [](const crow::request& req, const string& id) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto result = ReportService::markResolved(*username, id);
        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        return crow::response(204);
    };

    CROW_ROUTE(app, "/api/reports").methods("POST"_method)(createReportHandler);
    CROW_ROUTE(app, "/api/reports").methods("GET"_method)(listReportsHandler);
    CROW_ROUTE(app, "/api/reports/<string>/resolve").methods("PUT"_method)(resolveReportHandler);
}
