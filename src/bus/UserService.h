#ifndef USERSERVICE_H
#define USERSERVICE_H
#include "../dal/UserDAL.h"
#include <string>
#include <vector>
using std::string;
using std::vector;

class UserService {
private:
    UserDAL userDAL;
public:
    void createUser(UserDTO newUser);
    bool deleteUser(string userId);
    vector<UserDTO> getAllUsers();
};
#endif