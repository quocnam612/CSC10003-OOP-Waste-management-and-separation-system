#ifndef BASEDTO_H
#define BASEDTO_H

#include <string>
#include <iostream>
using std::string;
using std::cout;

class BaseDTO {
protected:
    string id;

public:
    BaseDTO(string id = "") : id(id) {}
    virtual ~BaseDTO() {}

    string getId() const { return id; }
    void setId(string newId) { id = newId; }
    
    virtual void displayInfo() const {
        cout << "ID: " << id << "\n";
    }
};

#endif