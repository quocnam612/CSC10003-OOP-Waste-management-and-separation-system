#include "ProfileDTO.h"

ProfileDTO::ProfileDTO()
    : fullName(""), email(""), phone(""), address(""), avatarUrl("") {}

ProfileDTO::ProfileDTO(const string& f,
                       const string& e,
                       const string& p,
                       const string& a,
                       const string& av)
    : fullName(f), email(e), phone(p), address(a), avatarUrl(av) {}

const string& ProfileDTO::getFullName() const { return fullName; }
const string& ProfileDTO::getEmail() const { return email; }
const string& ProfileDTO::getPhone() const { return phone; }
const string& ProfileDTO::getAddress() const { return address; }
const string& ProfileDTO::getAvatarUrl() const { return avatarUrl; }

void ProfileDTO::setFullName(const string& v) { fullName = v; }
void ProfileDTO::setEmail(const string& v) { email = v; }
void ProfileDTO::setPhone(const string& v) { phone = v; }
void ProfileDTO::setAddress(const string& v) { address = v; }
void ProfileDTO::setAvatarUrl(const string& v) { avatarUrl = v; }