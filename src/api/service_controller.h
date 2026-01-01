#pragma once

#include "crow.h"

class ServiceController {
public:
    static void registerRoutes(crow::SimpleApp& app);
};
