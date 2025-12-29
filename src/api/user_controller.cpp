#include "user_controller.h"
#include "../bus/user_service.h"
#include "../bus/session_manager.h"

void UserController::registerRoutes(crow::SimpleApp& app) {
    auto updateProfileHandler = [](const crow::request& req) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto body = crow::json::load(req.body);
        if (!body || !body.has("name") || !body.has("phone") || !body.has("region")) {
            return crow::response(400, "Invalid payload");
        }

        auto result = UserService::updateProfile(
            *username,
            body["name"].s(),
            body["phone"].s(),
            body["region"].i()
        );

        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        return crow::response(200, "Profile updated");
    };

    CROW_ROUTE(app, "/api/user/about").methods("PUT"_method)(updateProfileHandler);

    auto changePasswordHandler = [](const crow::request& req) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto body = crow::json::load(req.body);
        if (!body || !body.has("currentPassword") || !body.has("newPassword")) {
            return crow::response(400, "Invalid payload");
        }

        auto result = UserService::changePassword(
            *username,
            body["currentPassword"].s(),
            body["newPassword"].s()
        );

        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        return crow::response(200, "Password changed");
    };

    CROW_ROUTE(app, "/api/user/change-password").methods("PUT"_method)(changePasswordHandler);
}
