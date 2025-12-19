#ifndef BASEDTO_H
#define BASEDTO_H

#include <string>
#include <iostream>
using std::string;

class BaseDTO {
public:
    string id;
    string createAt;
    string updateAt;

    virtual short getRole() const = 0;
    virtual ~BaseDTO() = default;
};

#endif