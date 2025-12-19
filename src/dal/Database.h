#ifndef DATABASE_H
#define DATABASE_H

#include <mongocxx/v_noabi/mongocxx/client.hpp>
#include <mongocxx/v_noabi/mongocxx/instance.hpp>
#include <mongocxx/v_noabi/mongocxx/database.hpp>

class Database {
private:
    static Database* _instance;

    mongocxx::instance _mongoInstance;
    mongocxx::client _client;
    mongocxx::database _db;

    Database();

public:
    static Database& instance();
    mongocxx::database getDB();
};

#endif