#include "SettingDAL.h"
#include "Database.h"
#include <bsoncxx/builder/stream/document.hpp>
#include <mongocxx/options/update.hpp>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

bool SettingDAL::upsert(const std::string& managerId,
                        const bsoncxx::document::value& settingDoc) {
    auto col = Database::instance().getDB()["settings"];

    auto filter = document{} << "managerId" << managerId << finalize;
    auto update = document{} << "$set" << settingDoc.view() << finalize;

    auto result = col.update_one(
        filter.view(),
        update.view(),
        mongocxx::options::update{}.upsert(true)
    );

    return result.has_value();
}

std::optional<bsoncxx::document::value>
SettingDAL::getByManagerId(const std::string& managerId) {
    auto col = Database::instance().getDB()["settings"];

    auto filter = document{} << "managerId" << managerId << finalize;
    auto result = col.find_one(filter.view());

    if (result) return *result;
    return std::nullopt;
}