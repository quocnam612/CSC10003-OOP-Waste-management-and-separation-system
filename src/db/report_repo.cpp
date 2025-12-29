#include "report_repo.h"
#include "connect.h"

bool ReportRepository::insertReport(const bsoncxx::document::view_or_value& reportDoc) {
    auto result = MongoConnection::reports().insert_one(reportDoc);
    return static_cast<bool>(result);
}
