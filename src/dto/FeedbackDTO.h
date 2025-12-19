#ifndef FEEDBACKDTO_H
#define FEEDBACKDTO_H
#include <string>
using std::string;
class FeedbackDTO {
private:
    string id;
    string userId;
    string content;
    int rating;
    string createdAt;

public:
    FeedbackDTO();
    FeedbackDTO(const string& id,
                const string& userId,
                const string& content,
                int rating,
                const string& createdAt);

    const string& getId() const;
    const string& getUserId() const;
    const string& getContent() const;
    int getRating() const;
    const string& getCreatedAt() const;

    void setContent(const string& value);
    void setRating(int value);

    bool isValidRating() const;
};
#endif