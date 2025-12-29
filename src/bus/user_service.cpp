#include "user_service.h"
#include "../db/user_repo.h"
#include "../bus/ultis.h"
#include <bsoncxx/types.hpp>

expected<bool, string> UserService::updateProfile(const string& username, const string& name, const string& phone, int region) {
    auto user = UserRepository::findByUsername(username);
    if (!user) {
        return unexpected("User not found");
    }

    if (!UserRepository::updateProfile(username, name, phone, region)) {
        return unexpected("Failed to update profile");
    }

    return true;
}

expected<bool, string> UserService::changePassword(const string& username, const string& currentPassword, const string& newPassword) {
    auto user = UserRepository::findByUsername(username);
    if (!user) {
        return unexpected("User not found");
    }

    auto view = user->view();
    string storedHash = string(view["password_hash"].get_string().value);
    string currentHash = utils::sha256(currentPassword);

    if (storedHash != currentHash) {
        return unexpected("Current password is incorrect");
    }

    string newHash = utils::sha256(newPassword);
    if (!UserRepository::updatePasswordHash(username, newHash)) {
        return unexpected("Failed to change password");
    }

    return true;
}
