#include "service_repo.h"
#include "connect.h"

#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/builder/stream/helpers.hpp>
#include <mongocxx/options/find.hpp>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

bool ServiceRepository::insertService(const bsoncxx::document::view_or_value& serviceDoc) {
    auto result = MongoConnection::services().insert_one(serviceDoc);
    return static_cast<bool>(result);
}

std::vector<bsoncxx::document::value> ServiceRepository::findServicesByUserId(const bsoncxx::oid& userId) {
    mongocxx::options::find options;
    options.sort(document{} << "created_at" << -1 << finalize);

    auto cursor = MongoConnection::services().find(
        document{} << "user" << userId << finalize,
        options
    );

    std::vector<bsoncxx::document::value> services;
    for (auto&& item : cursor) {
        services.emplace_back(bsoncxx::document::value(item));
    }

    return services;
}

bool ServiceRepository::deleteService(const bsoncxx::oid& serviceId, const bsoncxx::oid& userId) {
    auto result = MongoConnection::services().delete_one(
        document{} << "_id" << serviceId << "user" << userId << finalize
    );
    return result && result->deleted_count() > 0;
}
