#include "connect.h"

mongocxx::instance inst{};
mongocxx::client client{ mongocxx::uri("mongodb+srv://admin:admin@cluster0.xfihssv.mongodb.net/?appName=Cluster0") };
mongocxx::database db = client["green_route"];
mongocxx::collection usersCol = db["users"];
