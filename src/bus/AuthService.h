#ifndef AUTHSERVICE_H
#define AUTHSERVICE_H

#include "../dto/user/UserDTO.h"
#include "../dal/UserDAL.h"
#include <vector>
#include <string>
#include <expected>
using std ::string;
using std ::vector; 
using std ::expected;
using std ::unexpected;

class AuthService {
private:
    UserDAL userDAL;
    UserDTO currentUser;
    bool isLoggedIn;

public:
    AuthService();
    expected<UserDTO, string> login(string username, string password);

    void logout();
    UserDTO getCurrentUser();
    bool checkLoginStatus();
};

#endif