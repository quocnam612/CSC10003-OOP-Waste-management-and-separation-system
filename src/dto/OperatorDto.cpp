//
// Created by xdora on 12/13/2025.
//

#include "OperatorDto.h"

OperatorDTO::OperatorDTO()
    : UserDTO(RoleEnum::Operator, "", "", "", "") {}
OperatorDTO::OperatorDTO(const string& name, const string& username, const string& passwordHash, const string& phone)
    : UserDTO(RoleEnum::Operator, name, username, passwordHash, phone) {}
OperatorDTO::~OperatorDTO() {}