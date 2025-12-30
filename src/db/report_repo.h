#pragma once

#include <string>
#include <vector>
#include <bsoncxx/document/value.hpp>
#include <bsoncxx/document/view_or_value.hpp>
#include <bsoncxx/oid.hpp>

class ReportRepository {
public:
    static bool insertReport(const bsoncxx::document::view_or_value& reportDoc);
    static bool markResolved(const bsoncxx::oid& reportId, int region);
    static std::vector<bsoncxx::document::value> findReportsByRegion(int region);
};
