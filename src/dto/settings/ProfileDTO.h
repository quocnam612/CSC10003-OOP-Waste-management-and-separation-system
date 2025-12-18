#ifndef PROFILEDTO_H
#define PROFILEDTO_H

#include "SettingDTO.h"

class ProfileDTO : public SettingDTO {
private:
    string fullName;
    string phoneNumber;
    string location;

public:
    ProfileDTO(string userId, string name, string phone, string loc)
        : SettingDTO(userId, "User Profile Setting"), 
          fullName(name), phoneNumber(phone), location(loc) {}

    string getFullName() const { return fullName; }
    string getPhoneNumber() const { return phoneNumber; }
    string getLocation() const { return location; }

    void displayInfo() const override {
        cout << "Updating Profile for ID: " << getId() << "\n";
    }
};
#endif