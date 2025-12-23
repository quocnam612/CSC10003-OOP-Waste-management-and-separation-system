#pragma once

#include <mongocxx/client.hpp>
#include <mongocxx/collection.hpp>
#include <mongocxx/database.hpp>
#include <mongocxx/instance.hpp>
#include <mongocxx/uri.hpp>

extern mongocxx::instance inst;
extern mongocxx::client client;
extern mongocxx::database db;
extern mongocxx::collection usersCol;
