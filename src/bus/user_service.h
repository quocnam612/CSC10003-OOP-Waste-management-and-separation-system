#pragma once
#include <expected>
#include <string>
#include <vector>
#include <bsoncxx/document/value.hpp>

using std::expected, std::unexpected;
using std::string;

class UserService {
public:
    static expected<bool, string> updateProfile(const string& username, const string& name, const string& phone, int region);
    static expected<bool, string> changePassword(const string& username, const string& currentPassword, const string& newPassword);
    static expected<std::vector<bsoncxx::document::value>, string> getResidentsByManagerRegion(const string& managerUsername);
    static expected<std::vector<bsoncxx::document::value>, string> getWorkersByManagerRegion(const string& managerUsername);
};
