#include "FeedbackDTO.h"

FeedbackDTO::FeedbackDTO() : status(PENDING) {}
FeedbackDTO::FeedbackDTO(string id, string senderId, string content, FeedbackStatus status) 
    : id(id), senderId(senderId), content(content), status(status) {}

string FeedbackDTO::getId() const { return id; }
string FeedbackDTO::getSenderId() const { return senderId; }
string FeedbackDTO::getContent() const { return content; }
FeedbackStatus FeedbackDTO::getStatus() const { return status; }
void FeedbackDTO::setStatus(FeedbackStatus st) { status = st; }