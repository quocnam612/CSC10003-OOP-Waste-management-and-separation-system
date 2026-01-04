#include "ai_controller.h"

#include "../bus/session_manager.h"
#include "httplib.h"
#include "json.hpp"

#include <string>

using nlohmann::json;
using std::string;

namespace {
    constexpr const char* kDefaultModel = "gemma3:1b";
    constexpr const char* kOllamaHost  = "localhost";
    constexpr int         kOllamaPort  = 11434;
}

void AIController::registerRoutes(crow::SimpleApp& app) {
    auto handler = [](const crow::request& req) -> crow::response {
        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return crow::response(401, "Unauthorized");
        }

        auto body = crow::json::load(req.body);
        if (!body || !body.has("prompt") || body["prompt"].t() != crow::json::type::String) {
            return crow::response(400, "Invalid payload");
        }

        string model = kDefaultModel;
        if (body.has("model") && body["model"].t() == crow::json::type::String) {
            model = body["model"].s();
        }

        const string prompt = body["prompt"].s();

        httplib::Client client(kOllamaHost, kOllamaPort);
        json requestBody = {
            {"model", model},
            {"prompt", prompt},
            {"stream", false}
        };

        auto result = client.Post("/api/generate", requestBody.dump(), "application/json");
        if (!result) {
            return crow::response(502, "Unable to reach Ollama server");
        }

        if (result->status != 200) {
            crow::response errorResp(result->status);
            errorResp.set_header("Content-Type", "text/plain");
            errorResp.write(result->body);
            return errorResp;
        }

        auto jsonResponse = json::parse(result->body, nullptr, false);
        if (jsonResponse.is_discarded()) {
            return crow::response(502, "Invalid response from Ollama server");
        }

        string answer;
        if (jsonResponse.contains("response") && jsonResponse["response"].is_string()) {
            answer = jsonResponse["response"].get<string>();
        }

        crow::json::wvalue payload;
        payload["model"] = model;
        payload["response"] = answer;
        payload["user"] = *username;

        return crow::response(payload);
    };

    CROW_ROUTE(app, "/api/ai").methods("POST"_method)(handler);
}
