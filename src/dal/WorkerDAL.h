#ifndef WORKERDAL_H
#define WORKERDAL_H

#include <string>
#include <optional>
#include <bsoncxx/document/value.hpp>

class WorkerDAL {
public:
    static bool upsert(const std::string& accountId,
                       const bsoncxx::document::value& workerDoc);

    static std::optional<bsoncxx::document::value>
    getByAccountId(const std::string& accountId);
};

#endif // WORKERDAL_H