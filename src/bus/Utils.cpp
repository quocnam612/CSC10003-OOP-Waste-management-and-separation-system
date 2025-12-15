#include "Utils.h"
#include <ctime>

using namespace std;

string Utils::now() {
    time_t t = time(nullptr);
    return string(ctime(&t));
}