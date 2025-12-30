#pragma once
#include <optional>
#include <string>
#include <vector>
#include <bsoncxx/document/value.hpp>
#include <bsoncxx/document/view_or_value.hpp>

class UserRepository {
public:
    static std::optional<bsoncxx::document::value> findByUsername(const std::string& username);
    static bool usernameExists(const std::string& username);
    static bool insertUser(const bsoncxx::document::view_or_value& userDoc);
    static bool updateProfile(const std::string& username, const std::string& name, const std::string& phone, int region);
    static bool updatePasswordHash(const std::string& username, const std::string& newHash);
    static std::vector<bsoncxx::document::value> findUsersByRegionAndRole(int region, int role);
};
