#include "user_repo.h"
#include "connect.h"
#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/builder/stream/helpers.hpp>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

std::optional<bsoncxx::document::value> UserRepository::findByUsername(const std::string& username) {
    auto doc = MongoConnection::users().find_one(document{} << "username" << username << finalize);
    if (doc) {
        return doc;
    }
    return std::nullopt;
}

bool UserRepository::usernameExists(const std::string& username) {
    return static_cast<bool>(findByUsername(username));
}

bool UserRepository::insertUser(const bsoncxx::document::view_or_value& userDoc) {
    auto result = MongoConnection::users().insert_one(userDoc);
    return static_cast<bool>(result);
}
