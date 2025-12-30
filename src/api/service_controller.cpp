#include "service_controller.h"

#include "../bus/service_request_service.h"
#include "../bus/session_manager.h"

#include <string>

using std::string;

void ServiceController::registerRoutes(crow::SimpleApp& app) {
    auto createServiceHandler = [](const crow::request& req) {
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

    CROW_ROUTE(app, "/api/services").methods("POST"_method)(createServiceHandler);
}
