#include "router.h"
#include "auth_controller.h"
#include "user_controller.h"

void Router::init(crow::SimpleApp& app) {
    AuthController::registerRoutes(app);
    UserController::registerRoutes(app);
}
