#pragma once

#include <expected>
#include <string>

using std::expected;
using std::string;
using std::unexpected;

class ServiceRequestService {
public:
    static expected<bool, string> createRequest(
        const string& username,
        const string& district,
        const string& address,
        const string& note
    );
};
