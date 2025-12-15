#include "ProfileDTO.h"

ProfileDTO::ProfileDTO() {}
ProfileDTO::ProfileDTO(string name, string phone, string loc) 
    : fullName(name), phoneNumber(phone), location(loc) {}

string ProfileDTO::getFullName() const { return fullName; }
string ProfileDTO::getPhoneNumber() const { return phoneNumber; }
string ProfileDTO::getLocation() const { return location; }