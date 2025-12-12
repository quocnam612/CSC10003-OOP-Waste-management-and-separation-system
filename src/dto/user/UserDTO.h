#ifndef USERDTO_H
#define USERDTO_H

#include <string>
#include <iostream>
using std::string;
//Vai trò
enum UserRole {
    ADMIN,      
    USER    
};

class UserDTO {
private:
    string id;
    string username;
    string password;
    string fullName;
    string phoneNumber;
    string location;
    UserRole role;

public:
    UserDTO();
    UserDTO(string id, string user, string pass, string name, string phone,string location, UserRole role);
    ~UserDTO();

    //Chỉ đọc
    string getId() const;
    string getUsername() const;
    string getPassword() const;
    string getFullName() const;
    string getPhoneNumber() const;
    string getLocation() const;
    UserRole getRole() const;

    //Chỉnh sửa
    void setId(const string& newId);
    void setUsername(const string& newUser);
    void setPassword(const string& newPass);
    void setFullName(const string& newName);
    void setPhoneNumber(const string& newPhone);
    void setLocation(const string& newLocation);
    void setRole(UserRole newRole);
};

#endif // USERDTO_H