#ifndef ACCOUNTDTO_H
#define ACCOUNTDTO_H

#include "../base.h"
using std::string;


enum UserRole { ADMIN, USER, WORKER };

class AccountDTO : public BaseDTO {
protected:
    string username;
    string password;
    string fullName;
    string phoneNumber;
    string location;
    UserRole role;

public:
    AccountDTO(string id, string user, string pass, 
               string name, string phone, string loc, UserRole role)
        : BaseDTO(id), username(user), password(pass), 
          fullName(name), phoneNumber(phone), location(loc), role(role) {}

    virtual ~AccountDTO() {}

    // Getters
    string getUsername() const { return username; }
    string getPassword() const { return password; }
    string getFullName() const { return fullName; }
    string getPhoneNumber() const { return phoneNumber; }
    string getLocation() const { return location; }
    UserRole getRole() const { return role; }

    // Setters cơ bản
    void setUsername(string user) { username = user; }
    void setFullName(string name) { fullName = name; }
    void setPhoneNumber(string phone) { phoneNumber = phone; }
    void setLocation(string loc) { location = loc; }
    void setRole(UserRole r) { role = r; }
    void setPassword(string pass) { password = pass; }
};
#endif