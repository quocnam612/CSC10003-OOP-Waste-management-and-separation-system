#include "report_repo.h"
#include "connect.h"

#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/builder/stream/helpers.hpp>
#include <mongocxx/options/find.hpp>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

bool ReportRepository::insertReport(const bsoncxx::document::view_or_value& reportDoc) {
    auto result = MongoConnection::reports().insert_one(reportDoc);
    return static_cast<bool>(result);
}

std::vector<bsoncxx::document::value> ReportRepository::findReportsByRegion(int region) {
    mongocxx::options::find options;
    options.sort(document{} << "created_at" << -1 << finalize);

    auto cursor = MongoConnection::reports().find(
        document{} << "region" << region << finalize,
        options
    );

    std::vector<bsoncxx::document::value> reports;
    for (auto&& doc : cursor) {
        reports.emplace_back(bsoncxx::document::value(doc));
    }

    return reports;
}

bool ReportRepository::markResolved(const bsoncxx::oid& reportId, int region) {
    using bsoncxx::builder::stream::open_document;
    using bsoncxx::builder::stream::close_document;

    auto result = MongoConnection::reports().update_one(
        document{} << "_id" << reportId << "region" << region << finalize,
        document{} << "$set" << open_document
            << "resolved" << true
            << close_document << finalize
    );

    return result && result->modified_count() > 0;
}
