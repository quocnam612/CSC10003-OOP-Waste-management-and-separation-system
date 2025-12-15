#include "AuthService.h"

using std::vector;
using std::string;
using std::unexpected;
using std::expected;
AuthService::AuthService() {
    isLoggedIn = false;
}

expected<UserDTO, string> AuthService::login(string username, string password) {
    vector<UserDTO> users = userDAL.readUsers();
    
    for (const auto& user : users) { 
        if (user.getUsername() == username && user.getPassword() == password) {
            this->currentUser = user;
            this->isLoggedIn = true;
            return currentUser; 
        }
    }
    return unexpected("Ten dang nhap hoac mat khau khong dung!");
}

void AuthService::logout() {
    isLoggedIn = false;
    currentUser = UserDTO(); 
}

UserDTO AuthService::getCurrentUser() {
    return currentUser;
}

bool AuthService::checkLoginStatus() {
    return isLoggedIn;
}