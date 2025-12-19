#ifndef USERSERVICE_H
#define USERSERVICE_H

#include <vector>
#include <string>
#include <optional>
#include "../dto/UserDTO.h"
#include "../dal/UserDAL.h"

class UserBUS {
public:
    // UI sends UserDTO → BUS validates & processes → returns UserDTO
    static std::optional<UserDTO> createUser(const UserDTO& userDTO);
    
    // UI sends username → BUS queries DAL → returns UserDTO
    static std::optional<UserDTO> getUserByUsername(const std::string& username);
    
    // UI sends username → BUS deletes via DAL → returns success status
    static bool deleteUser(const std::string& username);
    
    // BUS validates UserDTO before processing
    static bool validateUserData(const UserDTO& userDTO);
};

#endif