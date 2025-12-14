#pragma once
#include <expected>
#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/json.hpp>
#include "../db/connect.h"

using std::string;
using std::expected, std::unexpected;

class AuthService {
public:
    static expected<bool,string> registerUser(short role, string username, string password, string phone, string name, int region);
    static expected<bsoncxx::document::value,string> loginUser(string username, string password);
};
