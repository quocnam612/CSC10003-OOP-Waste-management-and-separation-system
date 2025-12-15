#include "Database.h"
#include <fstream>

vector<string> Database::readLines(const string& path) {
    vector<string> out;
    ifstream f(path);
    string line;
    while (getline(f, line)) out.push_back(line);
    return out;
}

void Database::writeLines(const string& path, const vector<string>& lines) {
    ofstream f(path);
    for (auto& s : lines) f << s << "\n";
}
