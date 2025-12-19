#include "ManagerDTO.h"

ManagerDTO::ManagerDTO()
    : AccountDTO(ROLE_MANAGER, "", ""),
      name(""), phone(""),
      manageUsers(true),
      manageWorkers(true),
      manageSettings(true),
      setting() {}

ManagerDTO::ManagerDTO(const AccountDTO& acc)
    : AccountDTO(acc),
      name(""), phone(""),
      manageUsers(true),
      manageWorkers(true),
      manageSettings(true),
      setting() {}