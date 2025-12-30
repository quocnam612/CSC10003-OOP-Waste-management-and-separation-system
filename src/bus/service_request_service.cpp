#include "service_request_service.h"

#include "../db/service_repo.h"
#include "../db/user_repo.h"

#include <bsoncxx/builder/stream/document.hpp>
#include <bsoncxx/builder/stream/helpers.hpp>
#include <bsoncxx/types.hpp>
#include <chrono>

using bsoncxx::builder::stream::document;
using bsoncxx::builder::stream::finalize;

expected<bool, string> ServiceRequestService::createRequest(
    const string& username,
    const string& district,
    const string& address,
    const string& note
) {
    if (district.empty()) {
        return unexpected("District is required");
    }
    if (address.empty()) {
        return unexpected("Address is required");
    }

    auto user = UserRepository::findByUsername(username);
    if (!user) {
        return unexpected("User not found");
    }

    auto userView = user->view();
    if (!userView["_id"] || userView["_id"].type() != bsoncxx::type::k_oid) {
        return unexpected("User record invalid");
    }

    int region = 0;
    if (auto regionElement = userView["region"]; regionElement) {
        if (regionElement.type() == bsoncxx::type::k_int32) {
            region = regionElement.get_int32().value;
        } else if (regionElement.type() == bsoncxx::type::k_int64) {
            region = static_cast<int>(regionElement.get_int64().value);
        }
    }

    if (region <= 0) {
        return unexpected("User region not configured");
    }

    auto now = bsoncxx::types::b_date(std::chrono::system_clock::now());
    document doc{};
    doc << "district" << district
        << "region" << region
        << "address" << address
        << "note" << note
        << "user" << userView["_id"].get_oid().value
        << "created_at" << now;

    if (!ServiceRepository::insertService(doc.view())) {
        return unexpected("Failed to create service request");
    }

    return true;
}

expected<std::vector<bsoncxx::document::value>, string> ServiceRequestService::getRequestsForUser(
    const string& username
) {
    auto user = UserRepository::findByUsername(username);
    if (!user) {
        return unexpected("User not found");
    }

    auto userView = user->view();
    if (!userView["_id"] || userView["_id"].type() != bsoncxx::type::k_oid) {
        return unexpected("User record invalid");
    }

    auto userId = userView["_id"].get_oid().value;
    return ServiceRepository::findServicesByUserId(userId);
}

expected<std::vector<bsoncxx::document::value>, string> ServiceRequestService::getRequestsForManagerRegion(
    const string& username
) {
    auto user = UserRepository::findByUsername(username);
    if (!user) {
        return unexpected("User not found");
    }

    auto userView = user->view();
    int role = 0;
    if (auto roleElement = userView["role"]; roleElement) {
        if (roleElement.type() == bsoncxx::type::k_int32) {
            role = roleElement.get_int32().value;
        } else if (roleElement.type() == bsoncxx::type::k_int64) {
            role = static_cast<int>(roleElement.get_int64().value);
        }
    }

    if (role != 3) {
        return unexpected("Permission denied");
    }

    int region = 0;
    if (auto regionElement = userView["region"]; regionElement) {
        if (regionElement.type() == bsoncxx::type::k_int32) {
            region = regionElement.get_int32().value;
        } else if (regionElement.type() == bsoncxx::type::k_int64) {
            region = static_cast<int>(regionElement.get_int64().value);
        }
    }

    if (region <= 0) {
        return unexpected("Region not configured");
    }

    return ServiceRepository::findServicesByRegion(region);
}

expected<bool, string> ServiceRequestService::cancelRequest(
    const string& username,
    const string& serviceId
) {
    auto user = UserRepository::findByUsername(username);
    if (!user) {
        return unexpected("User not found");
    }

    auto userView = user->view();
    if (!userView["_id"] || userView["_id"].type() != bsoncxx::type::k_oid) {
        return unexpected("User record invalid");
    }

    bsoncxx::oid oid;
    try {
        oid = bsoncxx::oid(serviceId);
    } catch (const std::exception&) {
        return unexpected("Invalid service id");
    }

    if (!ServiceRepository::deleteService(oid, userView["_id"].get_oid().value)) {
        return unexpected("Service request not found");
    }

    return true;
}
