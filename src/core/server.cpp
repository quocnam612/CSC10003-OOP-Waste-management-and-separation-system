#include <cstdlib>
#include <iostream>
#include "crow.h"
#include "server.h"
#include "../api/router.h"

void start_server() {
    crow::SimpleApp app;

    CROW_ROUTE(app, "/") ([] {
        return crow::response(200, "Green Route API is running");
    });

    CROW_ROUTE(app, "/health") ([] {
        return crow::response(200, "OK");
    });

    Router::init(app);

    const char* port_env = std::getenv("PORT");
    int port = port_env ? std::stoi(port_env) : 5000;

    std::cout << "Server running on 0.0.0.0:" << port << std::endl;

    app.bindaddr("0.0.0.0").port(port).multithreaded().run();
}
