#include "UserBUS.h"

// UI creates UserDTO → BUS validates → DAL persists → BUS returns UserDTO
std::optional<UserDTO> UserBUS::createUser(const UserDTO& userDTO) {
    // Step 1: Validate UserDTO from UI
    if (!validateUserData(userDTO))
        return std::nullopt;
    
    // Step 2: Convert UserDTO to BSON document
    // TODO: bsoncxx::document::value doc = convertUserDTOToDocument(userDTO);
    
    // Step 3: Call DAL to persist to DB
    // TODO: if (!UserDAL::insert(doc))
    //     return std::nullopt;
    
    // Step 4: Return validated UserDTO back to UI
    return userDTO;
}

// BUS queries DAL and returns UserDTO to UI
std::optional<UserDTO> UserBUS::getUserByUsername(const std::string& username) {
    // Step 1: Call DAL to fetch BSON document from DB
    // TODO: auto result = UserDAL::findByUsername(username);
    
    // Step 2: Convert BSON document to UserDTO
    // TODO: if (result) {
    //         return convertDocumentToUserDTO(*result);
    //     }
    
    return std::nullopt;
}

// BUS deletes user via DAL
bool UserBUS::deleteUser(const std::string& username) {
    // TODO: Implement delete logic via DAL
    return false;
}

// BUS validates UserDTO structure
bool UserBUS::validateUserData(const UserDTO& userDTO) {
    // Validate username is not empty
    // Validate phone format
    // Validate address is not empty
    return true;
}