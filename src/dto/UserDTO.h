#ifndef USERDTO_H
#define USERDTO_H
#include "AccountDTO.h"
#include "ProfileDTO.h"
#include "FeedbackDTO.h"
#include <vector>
using std::vector;

class UserDTO : public AccountDTO {
public:
    string name;
    string phone;
    string address;

    ProfileDTO profile;
    vector<FeedbackDTO> feedbacks;

public:
    UserDTO();
    explicit UserDTO(const AccountDTO& acc);

    void addFeedback(const FeedbackDTO& fb);
};
#endif