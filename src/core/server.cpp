#include "crow.h"
#include "server.h"
#include "../api/router.h"

void start_server() {
    crow::SimpleApp app;

    Router::init(app);

    std::cout << "Server is running on http://0.0.0.0:5000\n";
    app.bindaddr("0.0.0.0").port(5000).multithreaded().run();
}
