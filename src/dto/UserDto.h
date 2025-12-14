#pragma once
#include <string>
#include <map>
using std::string, std::map;

class UserDTO {
private:
    short role;
    bool isActive;
    string name;
    string username;
    string passwordHash;
    string phone;
    string createAt;
    string updateAt;
public:
    UserDTO(short role, const string& name, const string& username, const string& passwordHash, const string& phone);
    void update();
    void deactivate();


    // Getters
    short getRole() const;
    bool getIsActive() const;
    string getName() const;
    string getUsername() const;
    string getPasswordHash() const;
    string getPhone() const;
    string getCreateAt() const;
    string getUpdateAt() const;
};

class UserDataDTO : public UserDTO {
private:
    int point;
    int streak;
    double balance;
    double multiplier;
public:
    UserDataDTO(short role, const string& name, const string& username, const string& passwordHash, const string& phone);
    void addPoint(int p);
    void addBalance(double b);
    void updateStreak(bool success);
    void updateMultiplier(double m);

    // Getters
    int getPoint() const;
    int getStreak() const;
    double getBalance() const;
    double getMultiplier() const;
};

class OperatorDTO : public UserDTO {

};

class AdminDTO : public UserDTO {

};