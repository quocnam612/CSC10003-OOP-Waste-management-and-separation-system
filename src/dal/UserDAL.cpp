#include "UserDAL.h"
#include "Database.h"
#include <bsoncxx/v_noabi/bsoncxx/builder/stream/document.hpp>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

bool UserDAL::insert(const bsoncxx::document::value& doc) {
    auto col = Database::instance().getDB()["accounts"];
    auto result = col.insert_one(doc.view());
    return result.has_value();
}

std::optional<bsoncxx::document::value>
UserDAL::findByUsername(const std::string& username) {
    auto col = Database::instance().getDB()["accounts"];

    auto filter = document{} << "username" << username << finalize;
    auto result = col.find_one(filter.view());

    if (result) return *result;
    return std::nullopt;
}
