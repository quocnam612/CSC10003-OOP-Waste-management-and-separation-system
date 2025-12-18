#ifndef USERDTO_H
#define USERDTO_H
#include "AccountDTO.h"
class UserDTO : public AccountDTO {
public:
    UserDTO(string id, string user, string pass, string name, string phone, string loc)
        : AccountDTO(id, user, pass, name, phone, loc, USER) {}
};

#endif