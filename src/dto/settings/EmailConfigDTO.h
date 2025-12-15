#ifndef EMAILCONFIGDTO_H
#define EMAILCONFIGDTO_H

#include <string>
using namespace std;

struct EmailConfigDTO {
    string smtp;
    string username;
    string password;
};

#endif