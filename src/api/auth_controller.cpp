#include "auth_controller.h"
#include "crow.h"
#include "../bus/auth_service.h"
using std::string;

void AuthController::registerRoutes(crow::SimpleApp& app) {
    CROW_ROUTE(app, "/api/auth/register").methods("POST"_method)
    ([](const crow::request& req){
        auto body = crow::json::load(req.body);

        short role = body["role"].i();
        string username = body["username"].s();
        string password = body["password"].s();
        string phone = body["phone"].s();
        string name = body["name"].s();
        int region = body["region"].i();

        auto result = AuthService::registerUser(role, username, password, phone, name, region);

        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        return crow::response(200, "Registration success");
    });


    CROW_ROUTE(app, "/api/auth/login").methods("POST"_method)
    ([](const crow::request& req){
        auto body = crow::json::load(req.body);

        string username = body["username"].s();
        string password = body["password"].s();

        auto result = AuthService::loginUser(username, password);

        if (!result.has_value())
            return crow::response(401, result.error());

        // Return document as JSON:
        auto view = result.value().view();
        return crow::response(200, bsoncxx::to_json(view));
    });

}
