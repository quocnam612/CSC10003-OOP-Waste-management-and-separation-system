#ifndef DATABASE_H
#define DATABASE_H

#include <string>
#include <vector>
using namespace std;

class Database {
public:
    static vector<string> readLines(const string& path);
    static void writeLines(const string& path, const vector<string>& lines);
};

#endif