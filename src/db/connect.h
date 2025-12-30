#pragma once
#include <mongocxx/client.hpp>
#include <mongocxx/instance.hpp>

class MongoConnection {
public:
    static mongocxx::collection users();
    static mongocxx::collection regions();
    static mongocxx::collection reports();
    static mongocxx::collection services();

private:
    static mongocxx::client& client();
};
