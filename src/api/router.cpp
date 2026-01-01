#include "router.h"
#include "auth_controller.h"
#include "user_controller.h"
#include "region_controller.h"
#include "report_controller.h"
#include "service_controller.h"
#include "route_controller.h"

void Router::init(crow::SimpleApp& app) {
    AuthController::registerRoutes(app);
    UserController::registerRoutes(app);
    RegionController::registerRoutes(app);
    ReportController::registerRoutes(app);
    ServiceController::registerRoutes(app);
    RouteController::registerRoutes(app);
}
