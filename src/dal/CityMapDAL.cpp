#include "CityMapDAL.h"
#include "Database.h"
#include <bsoncxx/v_noabi/bsoncxx/builder/stream/document.hpp>
#include <mongocxx/v_noabi/mongocxx/options/update.hpp>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

bool CityMapDAL::upsert(const std::string& workerId,
                        const bsoncxx::document::value& cityMapDoc) {
    auto col = Database::instance().getDB()["city_maps"];

    auto filter = document{} << "workerId" << workerId << finalize;
    auto update = document{} << "$set" << cityMapDoc.view() << finalize;

    auto result = col.update_one(
        filter.view(),
        update.view(),
        mongocxx::options::update{}.upsert(true)
    );

    return result.has_value();
}

std::vector<bsoncxx::document::value>
CityMapDAL::getByWorkerId(const std::string& workerId) {
    auto col = Database::instance().getDB()["city_maps"];

    auto cursor = col.find(document{} << "workerId" << workerId << finalize);
    std::vector<bsoncxx::document::value> result;

    for (auto&& doc : cursor) {
        result.emplace_back(bsoncxx::document::value(doc));
    }
    return result;
}