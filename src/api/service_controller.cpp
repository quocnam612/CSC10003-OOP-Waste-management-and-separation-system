#include "service_controller.h"

#include "../bus/service_request_service.h"
#include "../bus/session_manager.h"

#include <bsoncxx/types.hpp>
#include <chrono>
#include <string>
#include <vector>

using std::string;

void ServiceController::registerRoutes(crow::SimpleApp& app) {
    auto createServiceHandler = [](const crow::request& req) -> crow::response {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto body = crow::json::load(req.body);
        if (!body || !body.has("district") || !body.has("address")) {
            return crow::response(400, "Invalid payload");
        }

        const string district = body["district"].s();
        const string address = body["address"].s();
        string note;
        if (body.has("note") && body["note"].t() == crow::json::type::String) {
            note = body["note"].s();
        }

        auto result = ServiceRequestService::createRequest(*username, district, address, note);
        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        return crow::response(201, "Service request created");
    };

    const auto serializeServices = [](const std::vector<bsoncxx::document::value>& serviceList) {
        crow::json::wvalue response;
        crow::json::wvalue::list list;
        list.reserve(serviceList.size());

        for (const auto& docValue : serviceList) {
            auto view = docValue.view();
            crow::json::wvalue item;

            if (auto idElement = view["_id"]; idElement && idElement.type() == bsoncxx::type::k_oid) {
                item["id"] = idElement.get_oid().value.to_string();
            }

            if (auto district = view["district"]; district && district.type() == bsoncxx::type::k_string) {
                item["district"] = std::string(district.get_string().value);
            } else {
                item["district"] = "";
            }

            if (auto address = view["address"]; address && address.type() == bsoncxx::type::k_string) {
                item["address"] = std::string(address.get_string().value);
            } else {
                item["address"] = "";
            }

            if (auto note = view["note"]; note && note.type() == bsoncxx::type::k_string) {
                item["note"] = std::string(note.get_string().value);
            } else {
                item["note"] = "";
            }

            int region = 0;
            if (auto regionElement = view["region"]; regionElement) {
                if (regionElement.type() == bsoncxx::type::k_int32) {
                    region = regionElement.get_int32().value;
                } else if (regionElement.type() == bsoncxx::type::k_int64) {
                    region = static_cast<int>(regionElement.get_int64().value);
                }
            }
            item["region"] = region;

            long long createdAtMs = 0;
            if (auto createdAt = view["created_at"]; createdAt && createdAt.type() == bsoncxx::type::k_date) {
                auto raw = createdAt.get_date().value;
                auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(raw);
                createdAtMs = ms.count();
            }
            item["created_at"] = createdAtMs;

            list.emplace_back(std::move(item));
        }

        response["services"] = crow::json::wvalue(list);
        return response;
    };

    auto listServicesHandler = [serializeServices](const crow::request& req) -> crow::response {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto services = ServiceRequestService::getRequestsForUser(*username);
        if (!services.has_value()) {
            return crow::response(400, services.error());
        }

        auto payload = serializeServices(services.value());
        return crow::response(payload);
    };

    auto listRegionServicesHandler = [serializeServices](const crow::request& req) -> crow::response {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto services = ServiceRequestService::getRequestsForManagerRegion(*username);
        if (!services.has_value()) {
            if (services.error() == "Permission denied") {
                return crow::response(403, services.error());
            }
            return crow::response(400, services.error());
        }

        auto payload = serializeServices(services.value());
        return crow::response(payload);
    };

    auto deleteServiceHandler = [](const crow::request& req, const string& id) -> crow::response {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto result = ServiceRequestService::cancelRequest(*username, id);
        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        return crow::response(204);
    };

    CROW_ROUTE(app, "/api/services").methods("POST"_method)(createServiceHandler);
    CROW_ROUTE(app, "/api/services").methods("GET"_method)(listServicesHandler);
    CROW_ROUTE(app, "/api/services/region").methods("GET"_method)(listRegionServicesHandler);
    CROW_ROUTE(app, "/api/services/<string>").methods("DELETE"_method)(deleteServiceHandler);
}
