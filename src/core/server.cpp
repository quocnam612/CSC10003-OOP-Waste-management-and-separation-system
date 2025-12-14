#include "crow.h"
#include "server.h"
#include "../api/router.h"

void start_server() {
    crow::SimpleApp app;

    Router::init(app);

    std::cout << "Server is running on http://localhost:5000\n";
    app.port(5000).multithreaded().run();
}
