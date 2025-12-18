// src/dal/ProfileDAL.cpp
#include "ProfileDAL.h"
#include "Database.h"
#include "../bus/Utils.h"

using std::vector;

bool ProfileDAL::updateInfo(string userId, ProfileDTO newInfo) {
    vector<string> lines = Database::readFile(FILE_PATH);
    vector<string> newLines;
    bool found = false;

    for (const string& line : lines) {
        vector<string> data = Utils::split(line, '|');
        if (data.size() >= 7 && data[0] == userId) {
            string updated = data[0] + "|" + data[1] + "|" + data[2] + "|" +
                             newInfo.getFullName() + "|" + 
                             newInfo.getPhoneNumber() + "|" + 
                             newInfo.getLocation() + "|" + 
                             data[6];
            newLines.push_back(updated);
            found = true;
        } else {
            newLines.push_back(line);
        }
    }
    if (found) Database::writeFile(FILE_PATH, newLines);
    return found;
}

bool ProfileDAL::updatePassword(string userId, string newPassword) {
    vector<string> lines = Database::readFile(FILE_PATH);
    vector<string> newLines;
    bool found = false;

    for (const string& line : lines) {
        vector<string> data = Utils::split(line, '|');
        if (data.size() >= 7 && data[0] == userId) {
            string updated = data[0] + "|" + data[1] + "|" + newPassword + "|" +
                             data[3] + "|" + data[4] + "|" + data[5] + "|" + data[6];
            newLines.push_back(updated);
            found = true;
        } else {
            newLines.push_back(line);
        }
    }
    if (found) Database::writeFile(FILE_PATH, newLines);
    return found;
}