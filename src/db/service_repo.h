#pragma once

#include <bsoncxx/document/view_or_value.hpp>

class ServiceRepository {
public:
    static bool insertService(const bsoncxx::document::view_or_value& serviceDoc);
};
