#include "path_repo.h"
#include "connect.h"

#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/builder/stream/helpers.hpp>
#include <mongocxx/options/find.hpp>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

bool PathRepository::insertPath(const bsoncxx::document::view_or_value& pathDoc) {
    auto result = MongoConnection::paths().insert_one(pathDoc);
    return static_cast<bool>(result);
}

std::vector<bsoncxx::document::value> PathRepository::findPathsByRegion(int region) {
    mongocxx::options::find options;
    options.sort(document{} << "created_at" << -1 << finalize);

    auto cursor = MongoConnection::paths().find(
        document{} << "region" << region << finalize,
        options
    );

    std::vector<bsoncxx::document::value> paths;
    for (auto&& item : cursor) {
        paths.emplace_back(bsoncxx::document::value(item));
    }

    return paths;
}

std::vector<bsoncxx::document::value> PathRepository::findPathsByRegionAndTeam(int region, int team) {
    mongocxx::options::find options;
    options.sort(document{} << "created_at" << -1 << finalize);

    auto cursor = MongoConnection::paths().find(
        document{} << "region" << region << "team" << team << finalize,
        options
    );

    std::vector<bsoncxx::document::value> paths;
    for (auto&& item : cursor) {
        paths.emplace_back(bsoncxx::document::value(item));
    }

    return paths;
}
