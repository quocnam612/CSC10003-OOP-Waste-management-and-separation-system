#pragma once

#include <optional>
#include <string>
#include <mutex>
#include <unordered_map>

using std::string;
using std::optional;
using std::unordered_map;
using std::mutex;

namespace crow {
    struct request;
}

class SessionManager {
private:
    unordered_map<string, string> tokenToUser_;
    mutex mutex_;
public:
    static SessionManager& instance();
    
    string randomToken(std::size_t length = 48);
    string issueToken(const string& username);
    optional<string> usernameFromToken(const string& token);
    optional<string> usernameFromRequest(const crow::request& req);
    void revokeToken(const string& token);
};
