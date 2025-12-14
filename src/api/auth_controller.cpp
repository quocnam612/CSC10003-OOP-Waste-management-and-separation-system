#include "auth_controller.h"
#include "crow.h"
#include "../bus/auth_service.h"

void AuthController::registerRoutes(crow::SimpleApp& app) {

    // REGISTER
    CROW_ROUTE(app, "/api/auth/register").methods("POST"_method)
    ([](const crow::request& req){
        auto body = crow::json::load(req.body);
        if (!body)
            return crow::response(400, "Invalid JSON");

        std::string email = body["email"].s();
        std::string password = body["password"].s();

        auto result = AuthService::registerUser(email, password);
        return crow::response(result.status, result.message);
    });

    // LOGIN
    CROW_ROUTE(app, "/api/auth/login").methods("POST"_method)
    ([](const crow::request& req){
        auto body = crow::json::load(req.body);
        if (!body)
            return crow::response(400, "Invalid JSON");

        std::string email = body["email"].s();
        std::string password = body["password"].s();

        auto result = AuthService::loginUser(email, password);
        return crow::response(result.status, result.message);
    });
}
