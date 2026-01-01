#include "user_controller.h"
#include "../bus/user_service.h"
#include "../bus/session_manager.h"
#include <bsoncxx/types.hpp>
#include <chrono>

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

    auto listCustomersHandler = [](const crow::request& req) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto result = UserService::getResidentsByManagerRegion(*username);
        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        crow::json::wvalue response;
        crow::json::wvalue::list list;
        list.reserve(result->size());

        for (const auto& doc : result.value()) {
            auto view = doc.view();
            crow::json::wvalue item;

            if (auto idElement = view["_id"]; idElement && idElement.type() == bsoncxx::type::k_oid) {
                item["id"] = idElement.get_oid().value.to_string();
            }

            if (auto nameElement = view["name"]; nameElement && nameElement.type() == bsoncxx::type::k_string) {
                item["name"] = std::string(nameElement.get_string().value);
            } else {
                item["name"] = "";
            }

            if (auto usernameElement = view["username"]; usernameElement && usernameElement.type() == bsoncxx::type::k_string) {
                item["username"] = std::string(usernameElement.get_string().value);
            } else {
                item["username"] = "";
            }

            if (auto phoneElement = view["phone"]; phoneElement && phoneElement.type() == bsoncxx::type::k_string) {
                item["phone"] = std::string(phoneElement.get_string().value);
            } else {
                item["phone"] = "";
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

            int team = -1;
            if (auto teamElement = view["team"]; teamElement) {
                if (teamElement.type() == bsoncxx::type::k_int32) {
                    team = teamElement.get_int32().value;
                } else if (teamElement.type() == bsoncxx::type::k_int64) {
                    team = static_cast<int>(teamElement.get_int64().value);
                }
            }
            item["team"] = team;

            bool isActive = true;
            if (auto activeElement = view["is_active"]; activeElement && activeElement.type() == bsoncxx::type::k_bool) {
                isActive = activeElement.get_bool().value;
            }
            item["is_active"] = isActive;

            long long createdAtMs = 0;
            if (auto createdAt = view["created_at"]; createdAt && createdAt.type() == bsoncxx::type::k_date) {
                auto raw = createdAt.get_date().value;
                auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(raw);
                createdAtMs = ms.count();
            }
            item["created_at"] = createdAtMs;

            list.emplace_back(std::move(item));
        }

        response["customers"] = crow::json::wvalue(list);
        crow::response resp;
        resp.code = 200;
        resp.set_header("Content-Type", "application/json");
        resp.body = response.dump();
        return resp;
    };

    auto listWorkersHandler = [](const crow::request& req) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto result = UserService::getWorkersByManagerRegion(*username);
        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        crow::json::wvalue response;
        crow::json::wvalue::list list;
        list.reserve(result->size());

        for (const auto& doc : result.value()) {
            auto view = doc.view();
            crow::json::wvalue item;

            if (auto idElement = view["_id"]; idElement && idElement.type() == bsoncxx::type::k_oid) {
                item["id"] = idElement.get_oid().value.to_string();
            }

            if (auto nameElement = view["name"]; nameElement && nameElement.type() == bsoncxx::type::k_string) {
                item["name"] = std::string(nameElement.get_string().value);
            } else {
                item["name"] = "";
            }

            if (auto usernameElement = view["username"]; usernameElement && usernameElement.type() == bsoncxx::type::k_string) {
                item["username"] = std::string(usernameElement.get_string().value);
            } else {
                item["username"] = "";
            }

            if (auto phoneElement = view["phone"]; phoneElement && phoneElement.type() == bsoncxx::type::k_string) {
                item["phone"] = std::string(phoneElement.get_string().value);
            } else {
                item["phone"] = "";
            }

            bool isActive = true;
            if (auto activeElement = view["is_active"]; activeElement && activeElement.type() == bsoncxx::type::k_bool) {
                isActive = activeElement.get_bool().value;
            }
            item["is_active"] = isActive;

            int region = 0;
            if (auto regionElement = view["region"]; regionElement) {
                if (regionElement.type() == bsoncxx::type::k_int32) {
                    region = regionElement.get_int32().value;
                } else if (regionElement.type() == bsoncxx::type::k_int64) {
                    region = static_cast<int>(regionElement.get_int64().value);
                }
            }
            item["region"] = region;

            int team = -1;
            if (auto teamElement = view["team"]; teamElement) {
                if (teamElement.type() == bsoncxx::type::k_int32) {
                    team = teamElement.get_int32().value;
                } else if (teamElement.type() == bsoncxx::type::k_int64) {
                    team = static_cast<int>(teamElement.get_int64().value);
                }
            }
            item["team"] = team;

            long long createdAtMs = 0;
            if (auto createdAt = view["created_at"]; createdAt && createdAt.type() == bsoncxx::type::k_date) {
                auto raw = createdAt.get_date().value;
                auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(raw);
                createdAtMs = ms.count();
            }
            item["created_at"] = createdAtMs;

            list.emplace_back(std::move(item));
        }

        response["workers"] = crow::json::wvalue(list);
        return crow::response(response);
    };

    CROW_ROUTE(app, "/api/customers").methods("GET"_method)(listCustomersHandler);
    CROW_ROUTE(app, "/api/workers").methods("GET"_method)(listWorkersHandler);
    auto listTeamHandler = [](const crow::request& req) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto result = UserService::getWorkersByTeam(*username);
        if (!result.has_value()) {
            return crow::response(400, result.error());
        }

        crow::json::wvalue response;
        crow::json::wvalue::list list;
        list.reserve(result->size());

        for (const auto& doc : result.value()) {
            auto view = doc.view();
            crow::json::wvalue item;

            if (auto idElement = view["_id"]; idElement && idElement.type() == bsoncxx::type::k_oid) {
                item["id"] = idElement.get_oid().value.to_string();
            }

            if (auto nameElement = view["name"]; nameElement && nameElement.type() == bsoncxx::type::k_string) {
                item["name"] = std::string(nameElement.get_string().value);
            } else {
                item["name"] = "";
            }

            if (auto usernameElement = view["username"]; usernameElement && usernameElement.type() == bsoncxx::type::k_string) {
                item["username"] = std::string(usernameElement.get_string().value);
            } else {
                item["username"] = "";
            }

            if (auto phoneElement = view["phone"]; phoneElement && phoneElement.type() == bsoncxx::type::k_string) {
                item["phone"] = std::string(phoneElement.get_string().value);
            } else {
                item["phone"] = "";
            }

            list.emplace_back(std::move(item));
        }

        response["members"] = crow::json::wvalue(list);
        crow::response resp;
        resp.code = 200;
        resp.set_header("Content-Type", "application/json");
        resp.body = response.dump();
        return resp;
    };
    CROW_ROUTE(app, "/api/team/members").methods("GET"_method)(listTeamHandler);

    auto updateStatusHandler = [](const crow::request& req, const string& userId) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        if (req.body.empty()) {
            return crow::response(400, "Invalid payload");
        }

        auto body = crow::json::load(req.body);
        if (!body || !body.has("is_active")) {
            return crow::response(400, "Invalid payload");
        }

        bool isActive;
        const auto valueType = body["is_active"].t();
        if (valueType == crow::json::type::True) {
            isActive = true;
        } else if (valueType == crow::json::type::False) {
            isActive = false;
        } else {
            return crow::response(400, "Invalid payload");
        }

        auto result = UserService::updateUserActiveStatus(*username, userId, isActive);
        if (!result.has_value()) {
            auto resp = crow::response(400, result.error());
            return resp;
        }

        return crow::response(204);
    };

    CROW_ROUTE(app, "/api/users/<string>/status").methods("PUT"_method)(updateStatusHandler);

    auto updateTeamHandler = [](const crow::request& req, const string& userId) {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        if (req.body.empty()) {
            return crow::response(400, "Invalid payload");
        }

        auto body = crow::json::load(req.body);
        if (!body || !body.has("team")) {
            return crow::response(400, "Invalid payload");
        }

        int teamValue = -1;
        const auto type = body["team"].t();
        if (type == crow::json::type::Number) {
            teamValue = body["team"].i();
        } else if (type == crow::json::type::Null) {
            teamValue = -1;
        } else {
            return crow::response(400, "Invalid payload");
        }

        if (teamValue < -1 || teamValue >= 1000) {
            return crow::response(400, "Team id invalid");
        }

        auto result = UserService::updateWorkerTeam(*username, userId, teamValue);
        if (!result.has_value()) {
            auto resp = crow::response(400, result.error());
            return resp;
        }

        return crow::response(204);
    };

    CROW_ROUTE(app, "/api/users/<string>/team").methods("PUT"_method)(updateTeamHandler);
}
