#include "region_repo.h"
#include "connect.h"

#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/builder/stream/helpers.hpp>
#include <bsoncxx/types.hpp>
#include <mongocxx/options/find.hpp>
#include <utility>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

std::vector<RegionRecord> RegionRepository::getAllRegions() {
    std::vector<RegionRecord> regions;

    mongocxx::options::find findOptions;
    findOptions.sort(document{} << "ID" << 1 << finalize);

    auto cursor = MongoConnection::regions().find({}, findOptions);
    for (const auto& doc : cursor) {
        RegionRecord record{};
        record.id = doc["ID"].get_int32().value;
        record.name = std::string(doc["name"].get_string().value);

        if (auto districtsElement = doc["district"]; districtsElement && districtsElement.type() == bsoncxx::type::k_array) {
            auto arrayView = districtsElement.get_array().value;
            for (const auto& districtValue : arrayView) {
                if (districtValue.type() == bsoncxx::type::k_string) {
                    record.districts.emplace_back(std::string(districtValue.get_string().value));
                }
            }
        }

        regions.emplace_back(std::move(record));
    }

    return regions;
}
