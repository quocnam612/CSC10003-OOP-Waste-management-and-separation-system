#include "ai_controller.h"
#include "../bus/session_manager.h"
#include "httplib.h"
#include "json.hpp"
#include <cstdlib>

namespace {
    crow::response makeResponse(int code, const std::string& body, const std::string& contentType) {
        crow::response response(code);
        response.set_header("Content-Type", contentType);
        response.set_header("Access-Control-Allow-Origin", "*");
        response.set_header("Access-Control-Allow-Methods", "POST, OPTIONS");
        response.set_header("Access-Control-Allow-Headers", "Content-Type, Authorization");
        response.body = body;
        return response;
    }

    crow::response textResponse(int code, const std::string& body) {
        return makeResponse(code, body, "text/plain; charset=utf-8");
    }

    crow::response jsonResponse(int code, const nlohmann::json& body) {
        return makeResponse(code, body.dump(), "application/json");
    }

    std::string ollamaBaseUrl() {
        const char* configuredUrl = std::getenv("OLLAMA_URL");
        if (!configuredUrl || std::string(configuredUrl).empty()) {
            configuredUrl = std::getenv("OLLAMA_HOST");
        }

        std::string baseUrl = configuredUrl && std::string(configuredUrl).size() > 0
            ? configuredUrl
            : "http://localhost:11434";

        if (baseUrl.rfind("http://", 0) != 0 && baseUrl.rfind("https://", 0) != 0) {
            baseUrl = "http://" + baseUrl;
        }

        return baseUrl;
    }
}

void AIController::registerRoutes(crow::SimpleApp& app) {
    CROW_ROUTE(app, "/api/ai").methods(crow::HTTPMethod::Post, crow::HTTPMethod::Options)
    ([](const crow::request& req) {
        if (req.method == crow::HTTPMethod::Options) {
            return textResponse(204, "");
        }

        auto username = SessionManager::instance().usernameFromRequest(req);
        if (!username) {
            return textResponse(401, "Unauthorized");
        }

        auto body = crow::json::load(req.body);
        if (!body || !body.has("prompt")) {
            return textResponse(400, "Invalid payload");
        }

        std::string prompt = body["prompt"].s();
        if (prompt.empty()) {
            return textResponse(400, "Prompt is required");
        }

        std::string model = "greenroute-helper";
        if (body.has("model")) {
            const std::string requestedModel = body["model"].s();
            if (!requestedModel.empty()) {
                model = requestedModel;
            }
        }

        httplib::Client ollama(ollamaBaseUrl());
        ollama.set_connection_timeout(5, 0);
        ollama.set_read_timeout(120, 0);

        nlohmann::json ollamaPayload = {
            {"model", model},
            {"prompt", prompt},
            {"stream", false}
        };

        auto ollamaResponse = ollama.Post("/api/generate", ollamaPayload.dump(), "application/json");
        if (!ollamaResponse) {
            return textResponse(503, "Không kết nối được Ollama. Hãy chạy: ollama serve");
        }

        if (ollamaResponse->status != 200) {
            return textResponse(ollamaResponse->status, ollamaResponse->body);
        }

        try {
            auto parsed = nlohmann::json::parse(ollamaResponse->body);
            const std::string responseText = parsed.value("response", "");
            if (responseText.empty()) {
                return textResponse(502, "Ollama trả về phản hồi rỗng.");
            }

            return jsonResponse(200, {
                {"model", model},
                {"response", responseText}
            });
        } catch (const std::exception&) {
            return textResponse(502, "Không đọc được phản hồi từ Ollama.");
        }
    });
}
