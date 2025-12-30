#include "service_repo.h"
#include "connect.h"

bool ServiceRepository::insertService(const bsoncxx::document::view_or_value& serviceDoc) {
    auto result = MongoConnection::services().insert_one(serviceDoc);
    return static_cast<bool>(result);
}
