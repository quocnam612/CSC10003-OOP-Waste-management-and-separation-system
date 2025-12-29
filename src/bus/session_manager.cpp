#include "session_manager.h"

#include <random>
using std::lock_guard;
using std::size_t;

SessionManager& SessionManager::instance() {
    static SessionManager instance;
    return instance;
}

string SessionManager::issueToken(const string& username) {
    lock_guard<mutex> lock(mutex_);
    string token;
    do {
        token = randomToken();
    } while (tokenToUser_.contains(token));
    tokenToUser_[token] = username;
    return token;
}

optional<string> SessionManager::usernameForToken(const string& token) {
    lock_guard<mutex> lock(mutex_);
    auto it = tokenToUser_.find(token);
    if (it == tokenToUser_.end()) {
        return std::nullopt;
    }
    return it->second;
}

void SessionManager::revokeToken(const string& token) {
    lock_guard<mutex> lock(mutex_);
    tokenToUser_.erase(token);
}

string SessionManager::randomToken(size_t length) {
    static constexpr char alphabet[] =
        "0123456789"
        "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        "abcdefghijklmnopqrstuvwxyz";
    thread_local std::mt19937_64 rng(std::random_device{}());
    std::uniform_int_distribution<size_t> dist(0, sizeof(alphabet) - 2);

    string token;
    token.reserve(length);
    for (size_t i = 0; i < length; ++i) {
        token.push_back(alphabet[dist(rng)]);
    }
    return token;
}
