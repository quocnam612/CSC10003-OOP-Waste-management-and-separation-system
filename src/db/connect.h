#pragma once
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>

class MongoConnection {
private:
    static mongocxx::client& client();
public:
    static mongocxx::collection users();
    static mongocxx::collection regions();
    static mongocxx::collection reports();
    static mongocxx::collection services();
    static mongocxx::collection paths();
};
