#pragma once
#include <ctime>
#include <string>
using std::string;

namespace utils {
    string sha256(const std::string& str);
    string timeParser(std::time_t t);
}
