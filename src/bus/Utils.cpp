#include "Utils.h"
#include <algorithm>
#include <cctype>
#include <sstream>
#include <functional>

namespace Utils {

    std::string hashPassword(const std::string& password) {
        std::hash<std::string> hasher;
        return std::to_string(hasher(password));
    }

    bool verifyPassword(const std::string& password,
                        const std::string& hashedPassword) {
        return hashPassword(password) == hashedPassword;
    }

    bool isValidPhone(const std::string& phone) {
        if (phone.length() < 9 || phone.length() > 11) return false;
        return std::all_of(phone.begin(), phone.end(), ::isdigit);
    }

    bool isValidEmail(const std::string& email) {
        auto atPos = email.find('@');
        auto dotPos = email.find('.', atPos);
        return atPos != std::string::npos &&
               dotPos != std::string::npos;
    }

    bool isValidAddress(const std::string& address) {
        return !trim(address).empty();
    }

    std::string trim(const std::string& s) {
        size_t start = 0;
        while (start < s.size() && std::isspace(s[start])) start++;

        size_t end = s.size();
        while (end > start && std::isspace(s[end - 1])) end--;

        return s.substr(start, end - start);
    }
}