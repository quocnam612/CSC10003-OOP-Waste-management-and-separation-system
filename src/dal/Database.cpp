#include "Database.h"
#include <fstream>
#include <iostream>

using std::ifstream;
using std::ofstream;
using std::ios;
using std::cerr;
using std::endl;

vector<string> Database::readFile(const string& filePath) {
    vector<string> lines;
    ifstream file(filePath);
    if (file.is_open()) {
        string line;
        while (getline(file, line)) {
            if (!line.empty()) lines.push_back(line);
        }
        file.close();
    }
    return lines;
}

void Database::writeFile(const string& filePath, const vector<string>& lines) {
    ofstream file(filePath);
    if (file.is_open()) {
        for (const auto& line : lines) {
            file << line << "\n";
        }
        file.close();
    } else {
        cerr << "Loi: Khong the mo file " << filePath << " de ghi.\n";
    }
}

void Database::appendLine(const string& filePath, const string& line) {
    ofstream file(filePath, ios::app);
    if (file.is_open()) {
        file << line << "\n";
        file.close();
    }
}