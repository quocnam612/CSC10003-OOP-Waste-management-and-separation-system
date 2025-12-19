#ifndef MANAGERDTO_H
#define MANAGERDTO_H

#include "AccountDTO.h"
#include "SettingDTO.h"

class ManagerDTO : public AccountDTO {
public:
    string name;
    string phone;

    bool manageUsers;
    bool manageWorkers;
    bool manageSettings;

    SettingDTO setting;

public:
    ManagerDTO();
    explicit ManagerDTO(const AccountDTO& acc);
};
#endif