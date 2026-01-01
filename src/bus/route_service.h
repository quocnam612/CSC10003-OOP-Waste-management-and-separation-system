#pragma once

#include <expected>
#include <string>
#include <vector>

#include <bsoncxx/document/value.hpp>

using std::expected;
using std::string;
using std::unexpected;

class RouteService {
public:
    static expected<std::vector<bsoncxx::document::value>, string> getRoutesForManagerRegion(
        const string& username
    );

    static expected<std::vector<bsoncxx::document::value>, string> getRoutesForWorkerTeam(
        const string& username
    );

    static expected<bool, string> createRoute(
        const string& username,
        const string& district,
        const string& shift,
        int team,
        const std::vector<string>& stops
    );
};
