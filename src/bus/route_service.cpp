#include "route_service.h"

#include "../db/path_repo.h"
#include "../db/user_repo.h"

#include <bsoncxx/builder/stream/array.hpp>
#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/builder/stream/helpers.hpp>
#include <bsoncxx/types.hpp>
#include <chrono>

using bsoncxx::builder::stream::array;
using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

expected<std::vector<bsoncxx::document::value>, string> RouteService::getRoutesForManagerRegion(
    const string& username
) {
    auto manager = UserRepository::findByUsername(username);
    if (!manager) {
        return unexpected("User not found");
    }

    auto view = manager->view();

    int role = 0;
    if (auto roleElement = view["role"]; roleElement) {
        if (roleElement.type() == bsoncxx::type::k_int32) {
            role = roleElement.get_int32().value;
        } else if (roleElement.type() == bsoncxx::type::k_int64) {
            role = static_cast<int>(roleElement.get_int64().value);
        }
    }

    if (role != 3) {
        return unexpected("Permission denied");
    }

    int region = 0;
    if (auto regionElement = view["region"]; regionElement) {
        if (regionElement.type() == bsoncxx::type::k_int32) {
            region = regionElement.get_int32().value;
        } else if (regionElement.type() == bsoncxx::type::k_int64) {
            region = static_cast<int>(regionElement.get_int64().value);
        }
    }

    if (region <= 0) {
        return unexpected("Region not configured");
    }

    auto routes = PathRepository::findPathsByRegion(region);
    return routes;
}

expected<std::vector<bsoncxx::document::value>, string> RouteService::getRoutesForWorkerTeam(
    const string& username
) {
    auto worker = UserRepository::findByUsername(username);
    if (!worker) {
        return unexpected("User not found");
    }

    auto view = worker->view();

    int role = 0;
    if (auto roleElement = view["role"]; roleElement) {
        if (roleElement.type() == bsoncxx::type::k_int32) {
            role = roleElement.get_int32().value;
        } else if (roleElement.type() == bsoncxx::type::k_int64) {
            role = static_cast<int>(roleElement.get_int64().value);
        }
    }

    if (role != 2) {
        return unexpected("Permission denied");
    }

    int region = 0;
    if (auto regionElement = view["region"]; regionElement) {
        if (regionElement.type() == bsoncxx::type::k_int32) {
            region = regionElement.get_int32().value;
        } else if (regionElement.type() == bsoncxx::type::k_int64) {
            region = static_cast<int>(regionElement.get_int64().value);
        }
    }

    int team = -1;
    if (auto teamElement = view["team"]; teamElement) {
        if (teamElement.type() == bsoncxx::type::k_int32) {
            team = teamElement.get_int32().value;
        } else if (teamElement.type() == bsoncxx::type::k_int64) {
            team = static_cast<int>(teamElement.get_int64().value);
        }
    }

    if (region <= 0 || team <= 0) {
        return std::vector<bsoncxx::document::value>{};
    }

    return PathRepository::findPathsByRegionAndTeam(region, team);
}

expected<bool, string> RouteService::createRoute(
    const string& username,
    const string& district,
    const string& shift,
    int team,
    const std::vector<string>& stops
) {
    if (district.empty()) {
        return unexpected("District is required");
    }
    if (shift.empty()) {
        return unexpected("Shift is required");
    }
    if (team <= 0) {
        return unexpected("Team is invalid");
    }

    size_t nonEmptyStops = 0;
    for (const auto& stop : stops) {
        if (!stop.empty()) {
            ++nonEmptyStops;
        }
    }
    if (nonEmptyStops == 0) {
        return unexpected("At least one route point is required");
    }

    auto manager = UserRepository::findByUsername(username);
    if (!manager) {
        return unexpected("User not found");
    }

    auto view = manager->view();

    int role = 0;
    if (auto roleElement = view["role"]; roleElement) {
        if (roleElement.type() == bsoncxx::type::k_int32) {
            role = roleElement.get_int32().value;
        } else if (roleElement.type() == bsoncxx::type::k_int64) {
            role = static_cast<int>(roleElement.get_int64().value);
        }
    }

    if (role != 3) {
        return unexpected("Permission denied");
    }

    int region = 0;
    if (auto regionElement = view["region"]; regionElement) {
        if (regionElement.type() == bsoncxx::type::k_int32) {
            region = regionElement.get_int32().value;
        } else if (regionElement.type() == bsoncxx::type::k_int64) {
            region = static_cast<int>(regionElement.get_int64().value);
        }
    }

    if (region <= 0) {
        return unexpected("Region not configured");
    }

    auto now = bsoncxx::types::b_date(std::chrono::system_clock::now());
    document doc{};
    doc << "district" << district
        << "shift" << shift
        << "team" << team
        << "region" << region
        << "created_at" << now;

    array routeArray;
    for (const auto& stop : stops) {
        if (stop.empty()) {
            continue;
        }
        routeArray << stop;
    }

    doc << "route" << routeArray;

    if (!PathRepository::insertPath(doc.view())) {
        return unexpected("Failed to create route");
    }

    return true;
}
