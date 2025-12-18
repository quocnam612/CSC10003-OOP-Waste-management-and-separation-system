//
// Created by xdora on 12/13/2025.
//

#ifndef GITPROGRESS_OPERATORDTO_H
#define GITPROGRESS_OPERATORDTO_H

#include "UserDto.h"
#include <vector>
using namespace std;

class OperatorDTO : public UserDTO {
public:
OperatorDTO();
OperatorDTO(const string& name, const string& username, const string& passwordHash, const string& phone);
~OperatorDTO();
public:

};

#endif