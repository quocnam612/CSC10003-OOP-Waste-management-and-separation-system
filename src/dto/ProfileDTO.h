#ifndef PROFILEDTO_H
#define PROFILEDTO_H
#include <string>
using std::string;
class ProfileDTO {
private:
    string fullName;
    string email;
    string phone;
    string address;
    string avatarUrl;
public:
    ProfileDTO();

    ProfileDTO(const string& fullName,
               const string& email,
               const string& phone,
               const string& address,
               const string& avatarUrl);

    const string& getFullName() const;
    const string& getEmail() const;
    const string& getPhone() const;
    const string& getAddress() const;
    const string& getAvatarUrl() const;
    
    void setFullName(const string& value);
    void setEmail(const string& value);
    void setPhone(const string& value);
    void setAddress(const string& value);
    void setAvatarUrl(const string& value);
};

#endif