#pragma once
#include <expected>
#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/json.hpp>
#include "../db/connect.h"

using std::expected, std::unexpected, std::string;

expected<bool, string> registerUser(short role, string username, string password, string phone, string name, int region);
expected<bsoncxx::document::value, string> loginUser(string username, string password);
