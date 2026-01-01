#include "connect.h"
#include <mongocxx/uri.hpp>
#include <mutex>

namespace {
    mongocxx::instance instance{};
    const mongocxx::uri& connection_uri() {
        static const mongocxx::uri uri{"mongodb+srv://admin:admin@cluster0.xfihssv.mongodb.net/?appName=Cluster0"};
        return uri;
    }
}

mongocxx::client& MongoConnection::client() {
    thread_local mongocxx::client threadClient{connection_uri()};
    return threadClient;
}

mongocxx::collection MongoConnection::users() {
    return client()["green_route"]["users"];
}

mongocxx::collection MongoConnection::regions() {
    return client()["green_route"]["regions"];
}

mongocxx::collection MongoConnection::reports() {
    return client()["green_route"]["reports"];
}

mongocxx::collection MongoConnection::services() {
    return client()["green_route"]["services"];
}

mongocxx::collection MongoConnection::paths() {
    return client()["green_route"]["paths"];
}