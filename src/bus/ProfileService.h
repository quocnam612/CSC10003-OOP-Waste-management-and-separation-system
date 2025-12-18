#ifndef PROFILESERVICE_H
#define PROFILESERVICE_H
#include "../dal/ProfileDAL.h"
#include "../dal/UserDAL.h" 
#include <string>
using std::string;

class ProfileService {
private:
    ProfileDAL profileDAL;
    UserDAL userDAL;
public:
    bool changePassword(string userId, string oldPass, string newPass);
    bool updateProfile(string userId, string name, string phone, string loc);
};
#endif