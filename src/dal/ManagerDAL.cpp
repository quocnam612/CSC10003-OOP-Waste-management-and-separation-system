#include "ManagerDAL.h"
#include "Database.h"
#include <bsoncxx/builder/stream/document.hpp>
#include <mongocxx/options/update.hpp>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

bool ManagerDAL::upsert(const std::string& accountId,
                        const bsoncxx::document::value& managerDoc) {
    auto col = Database::instance().getDB()["managers"];

    auto filter = document{} << "accountId" << accountId << finalize;
    auto update = document{} << "$set" << managerDoc.view() << finalize;

    auto result = col.update_one(
        filter.view(),
        update.view(),
        mongocxx::options::update{}.upsert(true)
    );

    return result.has_value();
}

std::optional<bsoncxx::document::value>
ManagerDAL::getByAccountId(const std::string& accountId) {
    auto col = Database::instance().getDB()["managers"];

    auto filter = document{} << "accountId" << accountId << finalize;
    auto result = col.find_one(filter.view());

    if (result) return *result;
    return std::nullopt;
}