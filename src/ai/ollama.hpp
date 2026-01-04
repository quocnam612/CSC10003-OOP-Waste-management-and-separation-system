#ifndef OLLAMA_HPP
#define OLLAMA_HPP
#include <string>
using std::string;

namespace rest {
    struct Response {
        string response;
    };

    class Client {
    public:
        Response generate(const string& model, const string& prompt);
    };

    void autoAsk(const string& model);
}

namespace cli {
    string escapeQuotes(const string& s);
    void autoAsk(const string& model);
}

#endif // OLLAMA_HPP