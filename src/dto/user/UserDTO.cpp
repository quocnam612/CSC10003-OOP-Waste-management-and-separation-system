#include "UserDTO.h"
UserDTO::UserDTO(){
    this->role=USER;
}

UserDTO::UserDTO(string id, string user, string pass, string name, string phone,string location, UserRole role){
    this->id=id;
    this->username=user;
    this->password=pass;
    this->fullName=name;
    this->phoneNumber=phone;
    this->location=location;
    this->role=role;
}

UserDTO::~UserDTO(){}

string UserDTO::getId() const{return this->id;}
string UserDTO::getUsername() const{return this->username;}
string UserDTO::getPassword() const{return this->password;}
string UserDTO::getFullName() const{return this->fullName;}
string UserDTO::getPhoneNumber() const{return this->phoneNumber;}
string UserDTO::getLocation() const{ return this->location;}
UserRole UserDTO::getRole() const { return role; }

void UserDTO::setId(const string& newId){this->id=newId;}
void UserDTO::setUsername(const string& newUser){this->username=newUser;}
void UserDTO::setPassword(const string& newPass){this->password=newPass;}
void UserDTO::setFullName(const string& newName){this->fullName=newName;}
void UserDTO::setPhoneNumber(const string& newPhone){this->phoneNumber=newPhone;}
void UserDTO::setLocation(const string& newLocation){ this->location=newLocation;}
void UserDTO::setRole(UserRole newRole) { this->role = newRole; }   

