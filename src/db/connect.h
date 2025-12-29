#pragma once
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>

class MongoConnection {
public:
    static mongocxx::collection users();
    static mongocxx::collection regions();
    static mongocxx::collection reports();
};
