#include "ollama.hpp"
#include "../include/httplib.h"
#include "../include/json.hpp"
#include <iostream>
#include <cstdlib>

#define RED_COLOR "\033[31m"
#define BLUE_COLOR "\033[34m"
#define GREEN_COLOR "\033[32m"

using std::string, std::to_string;
using std::cout, std::cin, std::getline, std::flush;
using std::system;
using namespace nlohmann;

rest::Response rest::Client::generate(const string& model, const string& prompt) {
    httplib::Client cli("localhost", 11434);

    json body = {
        {"model", model},
        {"prompt", prompt},
        {"stream", false}
    };

    auto res = cli.Post("/api/generate", body.dump(), "application/json");

    Response out;
    if (!res) {
        out.response = "[Error] HTTP request failed. Is Ollama running?";
        return out;
    }
    if (res->status != 200) {
        out.response = "[Error] HTTP " + to_string(res->status) + ": " + res->body;
        return out;
    }

    json resp_json = json::parse(res->body);
    out.response   = resp_json.value("response", "");
    return out;
}

void rest::autoAsk(const string& model) {
    string prompt;
    do {
        cout << RED_COLOR << "You: " << BLUE_COLOR;
        getline(cin, prompt);

        if (prompt == "exit") break;
        rest::Client client;
        rest::Response res = client.generate(model, prompt);
        cout << GREEN_COLOR <<"Ollama: " << BLUE_COLOR<< res.response << "\n";
    }
    while (true);
}

string cli::escapeQuotes(const string& s) {
    string out;
    for (char c : s) {
        if (c == '"') out += "\\\"";
        else out += c;
    }
    return out;
}

void cli::autoAsk(const string& model) {
    string prompt;
    do {
        cout << RED_COLOR << "You: " << BLUE_COLOR;
        getline(cin, prompt);

        if (prompt == "exit") break;
        cout << GREEN_COLOR << "Ollama: \n" << BLUE_COLOR << flush;
        string cmd = "ollama run " + model + " \"" + cli::escapeQuotes(prompt) + "\"";
        system(cmd.c_str());
    }
    while (true);
}
    