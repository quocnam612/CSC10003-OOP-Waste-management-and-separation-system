#ifndef FEEDBACKSERVICE_H
#define FEEDBACKSERVICE_H
#include "../dal/FeedbackDAL.h"
#include <vector>
#include <string>
using std::vector;
using std::string;

class FeedbackService {
private:
    FeedbackDAL dal;
public:
    void sendFeedback(string senderId, string content);
    vector<FeedbackDTO> getAll();
    vector<FeedbackDTO> getByUserId(string userId);
    void resolveFeedback(string feedbackId);
};
#endif