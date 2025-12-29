#pragma once

#include <optional>
#include <string>
#include <mutex>
#include <unordered_map>

using std::string;
using std::optional;
using std::unordered_map;
using std::mutex;

class SessionManager {
private:
    unordered_map<string, string> tokenToUser_;
    mutex mutex_;
public:
    static SessionManager& instance();
    
    string randomToken(std::size_t length = 48);
    string issueToken(const string& username);
    optional<string> usernameForToken(const string& token);
    void revokeToken(const string& token);
};
