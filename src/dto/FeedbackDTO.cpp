#include "FeedbackDTO.h"

FeedbackDTO::FeedbackDTO()
    : id(""), userId(""), content(""), rating(0), createdAt("") {}

FeedbackDTO::FeedbackDTO(const string& i,
                         const string& u,
                         const string& c,
                         int r,
                         const string& t)
    : id(i), userId(u), content(c), rating(r), createdAt(t) {}

const string& FeedbackDTO::getId() const { return id; }
const string& FeedbackDTO::getUserId() const { return userId; }
const string& FeedbackDTO::getContent() const { return content; }
int FeedbackDTO::getRating() const { return rating; }
const string& FeedbackDTO::getCreatedAt() const { return createdAt; }

void FeedbackDTO::setContent(const string& v) { content = v; }
void FeedbackDTO::setRating(int v) { rating = v; }

bool FeedbackDTO::isValidRating() const {
    return rating >= 1 && rating <= 5;
}