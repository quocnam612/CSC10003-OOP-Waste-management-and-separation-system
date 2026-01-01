#pragma once

#include <expected>
#include <string>
#include <vector>

#include <bsoncxx/document/value.hpp>

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

    static expected<std::vector<bsoncxx::document::value>, string> getRequestsForUser(
        const string& username
    );

    static expected<std::vector<bsoncxx::document::value>, string> getRequestsForManagerRegion(
        const string& username
    );

    static expected<bool, string> cancelRequest(
        const string& username,
        const string& serviceId
    );
};
