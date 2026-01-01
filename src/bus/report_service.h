#pragma once

#include <expected>
#include <string>
#include <vector>
#include <bsoncxx/document/value.hpp>

using std::string;
using std::expected, std::unexpected;

class ReportService {
public:
    static expected<bool, string> createReport(const string& username, const string& title, const string& content, int type);
    static expected<std::vector<bsoncxx::document::value>, string> getReportsForManagerRegion(const string& username);
    static expected<bool, string> markResolved(const string& username, const string& reportId, bool resolved);
};
