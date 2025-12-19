#ifndef ACCOUNTDTO_H
#define ACCOUNTDTO_H
#include "BaseDTO.h"

enum Role : short {
    ROLE_USER = 1,
    ROLE_WORKER = 2,
    ROLE_MANAGER = 3
};

class AccountDTO : public BaseDTO {
protected:
    short role;
    string username;
    string passwordHash;
    bool isActive;

public:
    AccountDTO();
    AccountDTO(short role,
               const string& username,
               const string& passwordHash,
               bool isActive = true);

    short getRole() const override;
    const string& getUsername() const;
    bool active() const;

    void setRole(short r);
    void setActive(bool active);

    virtual ~AccountDTO() = default;
};
#endif