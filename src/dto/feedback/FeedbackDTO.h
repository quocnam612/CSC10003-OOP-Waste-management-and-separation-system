#ifndef FEEDBACKDTO_H
#define FEEDBACKDTO_H
#include <string>
using std::string;

enum FeedbackStatus { PENDING = 0, RESOLVED = 1 };

class FeedbackDTO {
private:
    string id;
    string senderId;
    string content;
    FeedbackStatus status;
public:
    FeedbackDTO();
    FeedbackDTO(string id, string senderId, string content, FeedbackStatus status);
    string getId() const;
    string getSenderId() const;
    string getContent() const;
    FeedbackStatus getStatus() const;
    void setStatus(FeedbackStatus st);
};
#endif