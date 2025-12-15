#include "FeedbackDAL.h"
#include "Database.h"
#include "../bus/Utils.h"

vector<FeedbackDTO> FeedbackDAL::getAll() {
    vector<FeedbackDTO> list;
    vector<string> lines = Database::readFile(FILE_PATH);
    for (const string& line : lines) {
        vector<string> data = Utils::split(line, '|');
        if (data.size() >= 4) {
            FeedbackStatus st = (data[3] == "1") ? RESOLVED : PENDING;
            list.emplace_back(data[0], data[1], data[2], st);
        }
    }
    return list;
}

void FeedbackDAL::add(FeedbackDTO fb) {
    string stStr = (fb.getStatus() == RESOLVED) ? "1" : "0";
    string line = fb.getId() + "|" + fb.getSenderId() + "|" + fb.getContent() + "|" + stStr;
    Database::appendLine(FILE_PATH, line);
}

void FeedbackDAL::updateStatus(string feedbackId, FeedbackStatus newStatus) {
    vector<string> lines = Database::readFile(FILE_PATH);
    vector<string> newLines;
    for (const string& line : lines) {
        vector<string> data = Utils::split(line, '|');
        if (data.size() >= 4 && data[0] == feedbackId) {
            string stStr = (newStatus == RESOLVED) ? "1" : "0";
            string updated = data[0] + "|" + data[1] + "|" + data[2] + "|" + stStr;
            newLines.push_back(updated);
        } else {
            newLines.push_back(line);
        }
    }
    Database::writeFile(FILE_PATH, newLines);
}