#include "FeedbackService.h"
#include "Utils.h"

void FeedbackService::sendFeedback(string senderId, string content) {
    string newId = "FB" + Utils::getCurrentTimestamp();
    FeedbackDTO fb(newId, senderId, content, PENDING);
    dal.add(fb);
}

vector<FeedbackDTO> FeedbackService::getAll() {
    return dal.getAll();
}

vector<FeedbackDTO> FeedbackService::getByUserId(string userId) {
    vector<FeedbackDTO> all = dal.getAll();
    vector<FeedbackDTO> result;
    for (const auto& fb : all) {
        if (fb.getSenderId() == userId) {
            result.push_back(fb);
        }
    }
    return result;
}

void FeedbackService::resolveFeedback(string feedbackId) {
    dal.updateStatus(feedbackId, RESOLVED);
}