#include <expected>
#include "auth_service.h"
#include "../bus/ultis.h"
#include "../db/user_repo.h"

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;
using bsoncxx::builder::stream::open_document;
using bsoncxx::builder::stream::close_document;

expected<bool, string> AuthService::registerUser(short role, string username, string password, string phone, string name, int region) {
    // 1. Check if username exists
    if (UserRepository::usernameExists(username)) {
        std::cout << "Username already exists\n";
        return unexpected("Username already exists");
    }

    // 3. Hash password
    string hash = utils::sha256(password);

    // 4. Build user document
    auto now = bsoncxx::types::b_date(std::chrono::system_clock::now());
    bsoncxx::builder::stream::document doc{};
    doc << "role" << role
        << "username" << username
        << "password_hash" << hash
        << "phone" << phone
        << "name" << name
        << "region" << region
        << "is_active" << true
        << "created_at" << now
        << "updated_at" << now;

    switch (role) {
    case 1:  // User

        break;
    case 2:  // Worker

        break;
    case 3:  // Admin
    
        break;
    default:
        break;
    }

    // 5. Insert into DB
    auto result = UserRepository::insertUser(doc.view());

    return result;
}

expected<bsoncxx::document::value, string> AuthService::loginUser(string username, string password) {
    // 1. Find user
    auto userDoc = UserRepository::findByUsername(username);

    if (!userDoc) {
        std::cout << "User not found\n";
        return unexpected("User not found");
    }

    auto view = userDoc->view();

    // 2. Hash entered password
    std::string hash = utils::sha256(password);

    // 3. Compare hashes
    std::string storedHash = string(view["password_hash"].get_string().value);

    if (hash != storedHash) {
        std::cout << "Wrong password\n";
        return unexpected("Wrong password");
    }

    if (auto activeElement = view["is_active"]; activeElement && activeElement.type() == bsoncxx::type::k_bool) {
        if (!activeElement.get_bool().value) {
            return unexpected("Account is deactivated");
        }
    }

    // 4. Return the document (successful login)
    return *userDoc;
}
