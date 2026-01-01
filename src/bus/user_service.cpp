#include "user_service.h"
#include "../db/user_repo.h"
#include "../bus/ultis.h"
#include <bsoncxx/types.hpp>
#include <bsoncxx/oid.hpp>

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

expected<std::vector<bsoncxx::document::value>, string> UserService::getResidentsByManagerRegion(
    const string& managerUsername
) {
    auto manager = UserRepository::findByUsername(managerUsername);
    if (!manager) {
        return unexpected("User not found");
    }

    auto view = manager->view();
    if (!view["region"]) {
        return unexpected("Manager region not configured");
    }

    int region = 0;
    auto regionElement = view["region"];
    if (regionElement.type() == bsoncxx::type::k_int32) {
        region = regionElement.get_int32().value;
    } else if (regionElement.type() == bsoncxx::type::k_int64) {
        region = static_cast<int>(regionElement.get_int64().value);
    }

    if (region <= 0) {
        return unexpected("Manager region invalid");
    }

    auto residents = UserRepository::findUsersByRegionAndRole(region, 1);
    return residents;
}

expected<std::vector<bsoncxx::document::value>, string> UserService::getWorkersByManagerRegion(
    const string& managerUsername
) {
    auto manager = UserRepository::findByUsername(managerUsername);
    if (!manager) {
        return unexpected("User not found");
    }

    auto view = manager->view();
    int region = 0;
    if (auto regionElement = view["region"]; regionElement) {
        if (regionElement.type() == bsoncxx::type::k_int32) {
            region = regionElement.get_int32().value;
        } else if (regionElement.type() == bsoncxx::type::k_int64) {
            region = static_cast<int>(regionElement.get_int64().value);
        }
    }

    if (region <= 0) {
        return unexpected("Manager region invalid");
    }

    return UserRepository::findUsersByRegionAndRole(region, 2);
}

expected<std::vector<bsoncxx::document::value>, string> UserService::getWorkersByTeam(
    const string& workerUsername
) {
    auto worker = UserRepository::findByUsername(workerUsername);
    if (!worker) {
        return unexpected("User not found");
    }

    auto view = worker->view();

    int role = 0;
    if (auto roleElement = view["role"]; roleElement) {
        if (roleElement.type() == bsoncxx::type::k_int32) {
            role = roleElement.get_int32().value;
        } else if (roleElement.type() == bsoncxx::type::k_int64) {
            role = static_cast<int>(roleElement.get_int64().value);
        }
    }

    if (role != 2) {
        return unexpected("Permission denied");
    }

    int team = -1;
    if (auto teamElement = view["team"]; teamElement) {
        if (teamElement.type() == bsoncxx::type::k_int32) {
            team = teamElement.get_int32().value;
        } else if (teamElement.type() == bsoncxx::type::k_int64) {
            team = static_cast<int>(teamElement.get_int64().value);
        }
    }

    int region = 0;
    if (auto regionElement = view["region"]; regionElement) {
        if (regionElement.type() == bsoncxx::type::k_int32) {
            region = regionElement.get_int32().value;
        } else if (regionElement.type() == bsoncxx::type::k_int64) {
            region = static_cast<int>(regionElement.get_int64().value);
        }
    }

    if (team <= 0 || region <= 0) {
        return std::vector<bsoncxx::document::value>{};
    }

    auto members = UserRepository::findWorkersByTeam(team, region);
    return members;
}

expected<bool, string> UserService::updateUserActiveStatus(
    const string& managerUsername,
    const string& targetUserId,
    bool isActive
) {
    auto manager = UserRepository::findByUsername(managerUsername);
    if (!manager) {
        return unexpected("User not found");
    }

    auto view = manager->view();
    int role = 0;
    if (auto roleElement = view["role"]; roleElement) {
        if (roleElement.type() == bsoncxx::type::k_int32) {
            role = roleElement.get_int32().value;
        } else if (roleElement.type() == bsoncxx::type::k_int64) {
            role = static_cast<int>(roleElement.get_int64().value);
        }
    }

    if (role != 3) {
        return unexpected("Permission denied");
    }

    int region = 0;
    if (auto regionElement = view["region"]; regionElement) {
        if (regionElement.type() == bsoncxx::type::k_int32) {
            region = regionElement.get_int32().value;
        } else if (regionElement.type() == bsoncxx::type::k_int64) {
            region = static_cast<int>(regionElement.get_int64().value);
        }
    }

    if (region <= 0) {
        return unexpected("Manager region invalid");
    }

    bsoncxx::oid oid;
    try {
        oid = bsoncxx::oid(targetUserId);
    } catch (const std::exception&) {
        return unexpected("Invalid user id");
    }

    if (!UserRepository::updateActiveStatus(oid, region, isActive)) {
        return unexpected("User not found");
    }

    return true;
}

expected<bool, string> UserService::updateWorkerTeam(
    const string& managerUsername,
    const string& targetUserId,
    int team
) {
    auto manager = UserRepository::findByUsername(managerUsername);
    if (!manager) {
        return unexpected("User not found");
    }

    auto view = manager->view();
    int role = 0;
    if (auto roleElement = view["role"]; roleElement) {
        if (roleElement.type() == bsoncxx::type::k_int32) {
            role = roleElement.get_int32().value;
        } else if (roleElement.type() == bsoncxx::type::k_int64) {
            role = static_cast<int>(roleElement.get_int64().value);
        }
    }

    if (role != 3) {
        return unexpected("Permission denied");
    }

    int region = 0;
    if (auto regionElement = view["region"]; regionElement) {
        if (regionElement.type() == bsoncxx::type::k_int32) {
            region = regionElement.get_int32().value;
        } else if (regionElement.type() == bsoncxx::type::k_int64) {
            region = static_cast<int>(regionElement.get_int64().value);
        }
    }

    if (region <= 0) {
        return unexpected("Manager region invalid");
    }

    bsoncxx::oid oid;
    try {
        oid = bsoncxx::oid(targetUserId);
    } catch (const std::exception&) {
        return unexpected("Invalid user id");
    }

    if (!UserRepository::updateTeam(oid, region, team)) {
        return unexpected("User not found");
    }

    return true;
}
