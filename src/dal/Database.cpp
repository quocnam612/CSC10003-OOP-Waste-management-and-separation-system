#include "Database.h"
// #include "connect.h"  // TODO: Remove this if not needed

Database* Database::_instance = nullptr;

Database::Database()
    : _mongoInstance{},
      _client{ getMongoUri() },
      _db{ _client["waste_management"] } // tên database
{}

Database& Database::instance() {
    if (_instance == nullptr) {
        _instance = new Database();
    }
    return *_instance;
}

mongocxx::database Database::getDB() {
    return _db;
}