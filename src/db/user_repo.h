#pragma once
#include <optional>
#include <string>
#include <vector>
#include <bsoncxx/document/value.hpp>
#include <bsoncxx/document/view_or_value.hpp>
#include <bsoncxx/oid.hpp>

class UserRepository {
public:
    static std::optional<bsoncxx::document::value> findByUsername(const std::string& username);
    static bool usernameExists(const std::string& username);
    static bool insertUser(const bsoncxx::document::view_or_value& userDoc);
    static bool updateProfile(const std::string& username, const std::string& name, const std::string& phone, int region);
    static bool updatePasswordHash(const std::string& username, const std::string& newHash);
    static std::vector<bsoncxx::document::value> findUsersByRegionAndRole(int region, int role);
    static bool updateActiveStatus(const bsoncxx::oid& userId, int region, bool isActive);
    static std::vector<bsoncxx::document::value> findWorkersByTeam(int team, int region);
    static bool updateTeam(const bsoncxx::oid& userId, int region, int team);
};
