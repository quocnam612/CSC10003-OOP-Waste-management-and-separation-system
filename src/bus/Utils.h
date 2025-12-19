#ifndef UTILS_H
#define UTILS_H

#include <string>

namespace Utils {

    std::string hashPassword(const std::string& password);

    bool verifyPassword(const std::string& password,
                        const std::string& hashedPassword);

    bool isValidPhone(const std::string& phone);
    bool isValidEmail(const std::string& email);
    bool isValidAddress(const std::string& address);

    std::string trim(const std::string& s);
}

#endif