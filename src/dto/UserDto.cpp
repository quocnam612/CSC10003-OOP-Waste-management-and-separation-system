#include "UserDto.h"
#include "../utils/ultis.h"
#include <ctime>

UserDTO::UserDTO(short role, const string& name, const string& username, const string& passwordHash, const string& phone)
    : role(role), isActive(true), name(name), username(username), passwordHash(passwordHash), phone(phone) {
    isActive = true;
    createAt = "utils::timeParser(time(0))";
    updateAt = createAt;
}

// void UserDTO::update() {
//     updateAt = utils::timeParser(time(0));
// }

void UserDTO::deactivate() {
    isActive = false;
    update();
}

short UserDTO::getRole() const { return role; }
bool UserDTO::getIsActive() const { return isActive; }
string UserDTO::getName() const { return name; }
string UserDTO::getUsername() const { return username; }
string UserDTO::getPasswordHash() const { return passwordHash; }
string UserDTO::getPhone() const { return phone; }
string UserDTO::getCreateAt() const { return createAt; }
string UserDTO::getUpdateAt() const { return updateAt; }

UserDataDTO::UserDataDTO(short role, const string& name, const string& username, const string& passwordHash, const string& phone)
    : UserDTO(role, name, username, passwordHash, phone), point(0), streak(0), balance(0.0), multiplier(1.0) {}

