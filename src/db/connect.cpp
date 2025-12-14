#include "connect.h"
#include <mongocxx/uri.hpp>

static mongocxx::instance instance{};
static mongocxx::client client{ mongocxx::uri("mongodb+srv://admin:admin@cluster0.xfihssv.mongodb.net/?appName=Cluster0") };

mongocxx::collection MongoConnection::users() {
    return client["green_route"]["users"];
}
