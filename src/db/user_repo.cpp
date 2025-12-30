#include "user_repo.h"
#include "connect.h"
#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/builder/stream/helpers.hpp>
#include <chrono>
#include <mongocxx/options/find.hpp>

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

bool UserRepository::updateProfile(const std::string& username, const std::string& name, const std::string& phone, int region) {
    using bsoncxx::builder::stream::open_document;
    using bsoncxx::builder::stream::close_document;

    bsoncxx::builder::stream::document updateDoc{};
    updateDoc << "$set" << open_document
              << "name" << name
              << "phone" << phone
              << "region" << region
              << "updated_at" << bsoncxx::types::b_date(std::chrono::system_clock::now())
              << close_document;

    auto result = MongoConnection::users().update_one(
        document{} << "username" << username << finalize,
        updateDoc.view()
    );

    return result && result->modified_count() > 0;
}

bool UserRepository::updatePasswordHash(const std::string& username, const std::string& newHash) {
    using bsoncxx::builder::stream::open_document;
    using bsoncxx::builder::stream::close_document;

    bsoncxx::builder::stream::document updateDoc{};
    updateDoc << "$set" << open_document
              << "password_hash" << newHash
              << "updated_at" << bsoncxx::types::b_date(std::chrono::system_clock::now())
              << close_document;

    auto result = MongoConnection::users().update_one(
        document{} << "username" << username << finalize,
        updateDoc.view()
    );

    return result && result->modified_count() > 0;
}

std::vector<bsoncxx::document::value> UserRepository::findUsersByRegionAndRole(int region, int role) {
    mongocxx::options::find options;
    options.sort(document{} << "created_at" << -1 << finalize);

    auto cursor = MongoConnection::users().find(
        document{} << "region" << region << "role" << role << finalize,
        options
    );

    std::vector<bsoncxx::document::value> users;
    for (auto&& doc : cursor) {
        users.emplace_back(bsoncxx::document::value(doc));
    }

    return users;
}
