#include "ultis.h"

#include <iomanip>
#include <openssl/sha.h>
#include <sstream>
#include <ctime>

using std::string;
using std::stringstream;

namespace utils {
    string sha256(const string &str) {
        unsigned char hash[SHA256_DIGEST_LENGTH];
        SHA256((unsigned char*)str.c_str(), str.size(), hash);

        stringstream ss;
        for (int i = 0; i < SHA256_DIGEST_LENGTH; ++i)
            ss << std::hex << std::setw(2) << std::setfill('0') << (int)hash[i];

        return ss.str();
    }

    string timeParser (time_t t) {
        std::tm* local = std::localtime(&t);
        char buffer[80];
        std::strftime(buffer, sizeof(buffer), "%H:%M:%S %d-%m-%Y", local);
        return string(buffer);
    }
}
