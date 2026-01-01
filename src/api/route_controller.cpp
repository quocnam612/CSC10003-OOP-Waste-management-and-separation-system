#include "route_controller.h"

#include "../bus/route_service.h"
#include "../bus/session_manager.h"

#include <bsoncxx/types.hpp>
#include <chrono>
#include <string>
#include <vector>

using std::string;
using std::vector;

namespace {
    vector<string> parseStops(const crow::json::rvalue& body) {
        vector<string> stops;
        if (!body.has("route")) {
            return stops;
        }

        const auto& route = body["route"];
        if (route.t() == crow::json::type::List) {
            for (size_t i = 0; i < route.size(); ++i) {
                const auto& entry = route[i];
                if (entry.t() == crow::json::type::String) {
                    auto value = entry.s();
                    auto stop = std::string(value);
                    if (!stop.empty()) {
                        stops.emplace_back(stop);
                    }
                } else if (entry.t() == crow::json::type::Number) {
                    auto stop = static_cast<std::string>(entry);
                    if (!stop.empty()) {
                        stops.emplace_back(stop);
                    }
                }
            }
        } else if (route.t() == crow::json::type::String) {
            auto value = route.s();
            auto stop = std::string(value);
            if (!stop.empty()) {
                stops.emplace_back(stop);
            }
        }

        return stops;
    }
}

void RouteController::registerRoutes(crow::SimpleApp& app) {
    const auto serializeRoutes = [](const std::vector<bsoncxx::document::value>& routes) {
        crow::json::wvalue response;
        crow::json::wvalue::list routesList;
        routesList.reserve(routes.size());

        for (const auto& doc : routes) {
            auto view = doc.view();
            crow::json::wvalue item;

            if (auto idElement = view["_id"]; idElement && idElement.type() == bsoncxx::type::k_oid) {
                item["id"] = idElement.get_oid().value.to_string();
            }

            if (auto district = view["district"]; district && district.type() == bsoncxx::type::k_string) {
                item["district"] = std::string(district.get_string().value);
            } else {
                item["district"] = "";
            }

            if (auto shift = view["shift"]; shift && shift.type() == bsoncxx::type::k_string) {
                item["shift"] = std::string(shift.get_string().value);
            } else {
                item["shift"] = "";
            }

            int team = 0;
            if (auto teamElement = view["team"]; teamElement) {
                if (teamElement.type() == bsoncxx::type::k_int32) {
                    team = teamElement.get_int32().value;
                } else if (teamElement.type() == bsoncxx::type::k_int64) {
                    team = static_cast<int>(teamElement.get_int64().value);
                }
            }
            item["team"] = team;

            int region = 0;
            if (auto regionElement = view["region"]; regionElement) {
                if (regionElement.type() == bsoncxx::type::k_int32) {
                    region = regionElement.get_int32().value;
                } else if (regionElement.type() == bsoncxx::type::k_int64) {
                    region = static_cast<int>(regionElement.get_int64().value);
                }
            }
            item["region"] = region;

            crow::json::wvalue::list stops;
            if (auto routeElement = view["route"]; routeElement && routeElement.type() == bsoncxx::type::k_array) {
                auto routeView = routeElement.get_array().value;
                for (const auto& stopElement : routeView) {
                    if (stopElement.type() == bsoncxx::type::k_string) {
                        stops.emplace_back(std::string(stopElement.get_string().value));
                    } else if (stopElement.type() == bsoncxx::type::k_int32) {
                        stops.emplace_back(std::to_string(stopElement.get_int32().value));
                    } else if (stopElement.type() == bsoncxx::type::k_int64) {
                        stops.emplace_back(std::to_string(stopElement.get_int64().value));
                    }
                }
            }
            item["route"] = crow::json::wvalue(stops);

            long long createdAtMs = 0;
            if (auto createdAt = view["created_at"]; createdAt && createdAt.type() == bsoncxx::type::k_date) {
                auto raw = createdAt.get_date().value;
                auto ms = std::chrono::duration_cast<std::chrono::milliseconds>(raw);
                createdAtMs = ms.count();
            }
            item["created_at"] = createdAtMs;

            routesList.emplace_back(std::move(item));
        }

        response["routes"] = crow::json::wvalue(routesList);
        return response;
    };

    auto listRoutesHandler = [serializeRoutes](const crow::request& req) -> crow::response {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto routes = RouteService::getRoutesForManagerRegion(*username);
        if (!routes.has_value()) {
            if (routes.error() == "Permission denied") {
                return crow::response(403, routes.error());
            }
            return crow::response(400, routes.error());
        }

        auto payload = serializeRoutes(routes.value());
        return crow::response(payload);
    };

    auto listTeamRoutesHandler = [serializeRoutes](const crow::request& req) -> crow::response {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto routes = RouteService::getRoutesForWorkerTeam(*username);
        if (!routes.has_value()) {
            if (routes.error() == "Permission denied") {
                return crow::response(403, routes.error());
            }
            return crow::response(400, routes.error());
        }

        auto payload = serializeRoutes(routes.value());
        return crow::response(payload);
    };

    auto createRouteHandler = [](const crow::request& req) -> crow::response {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto body = crow::json::load(req.body);
        if (!body || !body.has("district") || !body.has("shift") || !body.has("team") || !body.has("route")) {
            return crow::response(400, "Invalid payload");
        }

        auto stops = parseStops(body);

        auto result = RouteService::createRoute(
            *username,
            body["district"].s(),
            body["shift"].s(),
            body["team"].i(),
            stops
        );

        if (!result.has_value()) {
            if (result.error() == "Permission denied") {
                return crow::response(403, result.error());
            }
            return crow::response(400, result.error());
        }

        return crow::response(201, "Route created");
    };

    CROW_ROUTE(app, "/api/routes").methods("GET"_method)(listRoutesHandler);
    CROW_ROUTE(app, "/api/routes/team").methods("GET"_method)(listTeamRoutesHandler);
    CROW_ROUTE(app, "/api/routes").methods("POST"_method)(createRouteHandler);
}
