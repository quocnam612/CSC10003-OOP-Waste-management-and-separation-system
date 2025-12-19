#ifndef USERDAL_H
#define USERDAL_H

#include <string>
#include <optional>
#include <bsoncxx/v_noabi/bsoncxx/document/value.hpp>

class UserDAL {
public:
    static bool insert(const bsoncxx::document::value& doc);
    static std::optional<bsoncxx::document::value>
    findByUsername(const std::string& username);
};

#endif // USERDAL_H