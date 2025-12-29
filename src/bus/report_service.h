#pragma once

#include <expected>
#include <string>

using std::string;
using std::expected, std::unexpected;

class ReportService {
public:
    static expected<bool, string> createReport(const string& username, const string& title, const string& content, int type);
};
