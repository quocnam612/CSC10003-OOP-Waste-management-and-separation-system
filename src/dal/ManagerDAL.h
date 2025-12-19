#ifndef MANAGERDAL_H
#define MANAGERDAL_H

#include <string>
#include <optional>
#include <bsoncxx/document/value.hpp>

class ManagerDAL {
public:
    static bool upsert(const std::string& accountId,
                       const bsoncxx::document::value& managerDoc);

    static std::optional<bsoncxx::document::value>
    getByAccountId(const std::string& accountId);
};

#endif