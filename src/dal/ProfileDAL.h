#ifndef PROFILEDAL_H
#define PROFILEDAL_H

#include "../dto/profile/ProfileDTO.h"
#include <string>
using std::string;

class ProfileDAL {
private:
    const string FILE_PATH = "data/users.txt";
public:
    bool updateInfo(string userId, ProfileDTO newInfo);
    bool updatePassword(string userId, string newPassword);
};
#endif