#include "FeedbackBUS.h"

// UI sends FeedbackDTO → BUS validates → DAL persists → returns FeedbackDTO
std::optional<FeedbackDTO> FeedbackBUS::sendFeedback(const FeedbackDTO& feedbackDTO) {
    // Step 1: Validate FeedbackDTO from UI
    if (!validateFeedback(feedbackDTO))
        return std::nullopt;
    
    // Step 2: Convert FeedbackDTO to BSON document
    // TODO: bsoncxx::document::value doc = convertFeedbackDTOToDocument(feedbackDTO);
    
    // Step 3: Call DAL to persist to DB
    // TODO: if (!FeedbackDAL::insert(doc))
    //     return std::nullopt;
    
    // Step 4: Return validated FeedbackDTO back to UI
    return feedbackDTO;
}

// BUS queries DAL and returns FeedbackDTO to UI
std::optional<FeedbackDTO> FeedbackBUS::getFeedbackById(const std::string& id) {
    // Step 1: Call DAL to fetch from DB by accountId and find by id
    // TODO: auto feedbacks = FeedbackDAL::getByAccountId(accountId);
    
    // Step 2: Find feedback with matching id and convert to DTO
    // TODO: for (const auto& doc : feedbacks) {
    //         auto feedback = convertDocumentToFeedbackDTO(doc);
    //         if (feedback.getId() == id) return feedback;
    //     }
    
    return std::nullopt;
}

// BUS queries DAL by account and returns vector of FeedbackDTO to UI
std::vector<FeedbackDTO> FeedbackBUS::getFeedbackByAccountId(const std::string& accountId) {
    // Step 1: Call DAL to fetch all feedback for account from DB
    // TODO: auto result = FeedbackDAL::getByAccountId(accountId);
    
    // Step 2: Convert BSON documents to FeedbackDTO objects
    // TODO: std::vector<FeedbackDTO> feedbacks;
    //     for (const auto& doc : result) {
    //         feedbacks.push_back(convertDocumentToFeedbackDTO(doc));
    //     }
    //     return feedbacks;
    
    return {};
}

// BUS validates FeedbackDTO structure
bool FeedbackBUS::validateFeedback(const FeedbackDTO& feedbackDTO) {
    // Validate rating is 1-5
    if (!feedbackDTO.isValidRating())
        return false;
    
    // Validate content is not empty
    // Validate userId is not empty
    return true;
}