#pragma once

#include <string>
#include <bsoncxx/document/value.hpp>
#include <bsoncxx/document/view_or_value.hpp>

class ReportRepository {
public:
    static bool insertReport(const bsoncxx::document::view_or_value& reportDoc);
};
