#include "report_controller.h"
#include "../bus/report_service.h"
#include "../bus/session_manager.h"
#include <optional>

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

    CROW_ROUTE(app, "/api/reports").methods("POST"_method)(createReportHandler);
}
