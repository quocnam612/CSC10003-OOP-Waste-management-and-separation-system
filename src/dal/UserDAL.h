#ifndef USERDAL_H
#define USERDAL_H

#include "../dto/user/UserDTO.h"
#include <vector>
#include <string>
#include <fstream>
#include <sstream>
using std::vector;
using std::string;
using std::ifstream;
using std::ofstream;
using std::istringstream;
using std::cout;
class UserDAL {
private:
    const string FILE_PATH = "data/users.txt";
    vector<string> split(const string& s, char delimiter);

public:
    vector<UserDTO> readUsers();
    void writeUsers(const vector<UserDTO>& users);
};

#endif // USERDAL_H