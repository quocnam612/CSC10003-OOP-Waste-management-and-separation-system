#pragma once
#include <optional>
#include <string>
#include <bsoncxx/document/value.hpp>
#include <bsoncxx/document/view_or_value.hpp>

class UserRepository {
public:
    static std::optional<bsoncxx::document::value> findByUsername(const std::string& username);
    static bool usernameExists(const std::string& username);
    static bool insertUser(const bsoncxx::document::view_or_value& userDoc);
};
