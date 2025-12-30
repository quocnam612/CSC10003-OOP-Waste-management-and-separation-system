#pragma once

#include <bsoncxx/document/view_or_value.hpp>
#include <bsoncxx/document/value.hpp>
#include <bsoncxx/oid.hpp>
#include <vector>

class ServiceRepository {
public:
    static bool insertService(const bsoncxx::document::view_or_value& serviceDoc);
    static std::vector<bsoncxx::document::value> findServicesByUserId(const bsoncxx::oid& userId);
    static bool deleteService(const bsoncxx::oid& serviceId, const bsoncxx::oid& userId);
};
