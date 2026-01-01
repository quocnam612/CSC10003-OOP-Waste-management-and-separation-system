#include "region_controller.h"
#include "../db/region_repo.h"

void RegionController::registerRoutes(crow::SimpleApp& app) {
    CROW_ROUTE(app, "/api/regions").methods("GET"_method)([]() {
        auto regions = RegionRepository::getAllRegions();

        crow::json::wvalue response;
        crow::json::wvalue::list list;
        list.reserve(regions.size());

        for (const auto& region : regions) {
            crow::json::wvalue jsonRegion;
            jsonRegion["id"] = region.id;
            jsonRegion["name"] = region.name;

            crow::json::wvalue::list districtsJson;
            districtsJson.reserve(region.districts.size());
            for (const auto& district : region.districts) {
                districtsJson.emplace_back(district);
            }

            jsonRegion["districts"] = crow::json::wvalue(districtsJson);
            list.emplace_back(std::move(jsonRegion));
        }

        response["regions"] = crow::json::wvalue(list);
        return response;
    });
}
