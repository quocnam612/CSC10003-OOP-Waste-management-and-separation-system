#ifndef FEEDBACKSERVICE_H
#define FEEDBACKSERVICE_H

#include <vector>
#include <string>
#include <optional>
#include "../dto/FeedbackDTO.h"
#include "../dal/FeedbackDAL.h"

class FeedbackBUS {
public:
    // UI sends FeedbackDTO → BUS validates → DAL persists → returns FeedbackDTO
    static std::optional<FeedbackDTO> sendFeedback(const FeedbackDTO& feedbackDTO);

    // BUS queries DAL by ID → returns FeedbackDTO to UI
    static std::optional<FeedbackDTO> getFeedbackById(const std::string& id);

    // BUS queries DAL by account → returns vector of FeedbackDTO to UI
    static std::vector<FeedbackDTO> getFeedbackByAccountId(const std::string& accountId);
    
    // BUS validates FeedbackDTO structure before processing
    static bool validateFeedback(const FeedbackDTO& feedbackDTO);
};

#endif