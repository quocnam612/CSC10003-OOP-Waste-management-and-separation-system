#pragma once
#include <expected>
#include <string>

using std::expected, std::unexpected;
using std::string;

class UserService {
public:
    static expected<bool, string> updateProfile(const string& username, const string& name, const string& phone, int region);
    static expected<bool, string> changePassword(const string& username, const string& currentPassword, const string& newPassword);
};
