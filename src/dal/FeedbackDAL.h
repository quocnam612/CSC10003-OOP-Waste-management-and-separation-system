#ifndef FEEDBACKDAL_H
#define FEEDBACKDAL_H

#include <string>
#include <vector>
#include <bsoncxx/v_noabi/bsoncxx/document/value.hpp>

class FeedbackDAL {
public:
    static bool insert(const bsoncxx::document::value& doc);

    static std::vector<bsoncxx::document::value>
    getByAccountId(const std::string& accountId);
};
#endif