#include "UserDTO.h"

UserDTO::UserDTO()
    : AccountDTO(ROLE_USER, "", ""), name(""), phone(""), address("") {}

UserDTO::UserDTO(const AccountDTO& acc)
    : AccountDTO(acc), name(""), phone(""), address("") {}

void UserDTO::addFeedback(const FeedbackDTO& fb) {
    feedbacks.push_back(fb);
}