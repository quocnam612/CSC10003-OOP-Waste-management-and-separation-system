#include "router.h"
#include "auth_controller.h"

void Router::init(crow::SimpleApp& app) {
    AuthController::registerRoutes(app);
}
