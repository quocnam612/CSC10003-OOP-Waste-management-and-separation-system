#ifndef UTILS_H
#define UTILS_H

#include <string>
#include <vector>
using std::string;
using std::vector;

class Utils {
public:
    static vector<string> split(const string& s, char delimiter);
    static string getCurrentTimestamp();
};

#endif