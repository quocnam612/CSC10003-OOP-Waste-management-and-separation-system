#include "UserService.h"

void UserService::createUser(UserDTO newUser) {
    vector<UserDTO> users = userDAL.readUsers();
    users.push_back(newUser);
    userDAL.writeUsers(users);
}

bool UserService::deleteUser(string userId) {
    vector<UserDTO> users = userDAL.readUsers();
    bool found = false;
    for (auto it = users.begin(); it != users.end(); ) {
        if (it->getId() == userId) {
            it = users.erase(it);
            found = true;
        } else {
            ++it;
        }
    }
    if (found) {
        userDAL.writeUsers(users);
    }
    return found;
}

vector<UserDTO> UserService::getAllUsers() {
    return userDAL.readUsers();
}