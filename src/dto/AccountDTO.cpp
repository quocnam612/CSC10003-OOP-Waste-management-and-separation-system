#include "AccountDTO.h"

AccountDTO::AccountDTO()
    : role(ROLE_USER), username(""), passwordHash(""), isActive(true) {}

AccountDTO::AccountDTO(short r,
                       const string& u,
                       const string& p,
                       bool a)
    : role(r), username(u), passwordHash(p), isActive(a) {}

short AccountDTO::getRole() const {
    return role;
}

const string& AccountDTO::getUsername() const {
    return username;
}

bool AccountDTO::active() const {
    return isActive;
}

void AccountDTO::setRole(short r) {
    role = r;
}

void AccountDTO::setActive(bool a) {
    isActive = a;
}