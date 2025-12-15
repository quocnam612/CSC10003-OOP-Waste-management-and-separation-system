#ifndef DATABASE_H
#define DATABASE_H

#include <string>
#include <vector>
using std::string;
using std::vector;

class Database {
public:
    static vector<string> readFile(const string& filePath);
    static void writeFile(const string& filePath, const vector<string>& lines);
    static void appendLine(const string& filePath, const string& line);
};

#endif