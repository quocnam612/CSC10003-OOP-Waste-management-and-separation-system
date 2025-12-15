#ifndef PROFILEDTO_H
#define PROFILEDTO_H
#include <string>
using std::string;

class ProfileDTO {
private:
    string fullName;
    string phoneNumber;
    string location;
public:
    ProfileDTO();
    ProfileDTO(string name, string phone, string loc);
    string getFullName() const;
    string getPhoneNumber() const;
    string getLocation() const;
};
#endif