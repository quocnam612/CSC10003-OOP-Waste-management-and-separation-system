#include "FeedbackDAL.h"
#include "Database.h"
#include <bsoncxx/v_noabi/bsoncxx/builder/stream/document.hpp>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

bool FeedbackDAL::insert(const bsoncxx::document::value& doc) {
    auto col = Database::instance().getDB()["feedbacks"];
    return col.insert_one(doc.view()).has_value();
}

std::vector<bsoncxx::document::value>
FeedbackDAL::getByAccountId(const std::string& accountId) {
    auto col = Database::instance().getDB()["feedbacks"];
    auto cursor = col.find(document{} << "accountId" << accountId << finalize);

    std::vector<bsoncxx::document::value> result;
    for (auto&& d : cursor) {
        result.emplace_back(bsoncxx::document::value(d));
    }
    return result;
}