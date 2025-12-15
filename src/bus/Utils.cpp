#include "Utils.h"
#include <sstream>
#include <ctime>

using std::istringstream;
using std::to_string;

vector<string> Utils::split(const string& s, char delimiter) {
    vector<string> tokens;
    string token;
    istringstream tokenStream(s);
    while (getline(tokenStream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}

string Utils::getCurrentTimestamp() {
    return to_string(time(0));
}