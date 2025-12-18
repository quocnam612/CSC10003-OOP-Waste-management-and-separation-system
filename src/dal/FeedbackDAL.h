#ifndef FEEDBACKDAL_H
#define FEEDBACKDAL_H
#include "../dto/feedback/FeedbackDTO.h"
#include <vector>
#include <string>
using std::vector;
using std::string;

class FeedbackDAL {
private:
    const string FILE_PATH = "data/feedbacks.txt";
public:
    vector<FeedbackDTO> getAll();
    void add(FeedbackDTO feedback);
    void updateStatus(string feedbackId, FeedbackStatus newStatus);
};
#endif