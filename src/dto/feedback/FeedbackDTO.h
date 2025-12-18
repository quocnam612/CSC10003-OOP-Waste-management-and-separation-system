#ifndef FEEDBACKDTO_H
#define FEEDBACKDTO_H

#include "../base.h"

enum FeedbackStatus { PENDING, RESOLVED };

class FeedbackDTO : public BaseDTO {
private:
    string senderId;
    string content;
    FeedbackStatus status;
    string adminReply;

public:
    FeedbackDTO(string id, string sender, string content)
        : BaseDTO(id), senderId(sender), content(content), status(PENDING) {}

    string getSenderId() const { return senderId; }
    string getContent() const { return content; }
    FeedbackStatus getStatus() const { return status; }
    string getAdminReply() const { return adminReply; }

    void setStatus(FeedbackStatus st) { status = st; }
    void setAdminReply(string reply) { 
        adminReply = reply;
        status = RESOLVED; 
    }
};
#endif