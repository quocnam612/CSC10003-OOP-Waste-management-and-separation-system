#include "UserDAL.h"
#include <iostream>
//hàm tách chuỗi
vector<string> UserDAL::split(const string& s, char delimiter) {
    vector<string> tokens;
    string token;
    istringstream tokenStream(s);
    while (getline(tokenStream, token, delimiter)) {
        tokens.push_back(token);
    }
    return tokens;
}
//đọc danh sách user từ file
vector<UserDTO> UserDAL::readUsers() {
    vector<UserDTO> users;
    ifstream file(FILE_PATH);

    if (!file.is_open()) return users;

    string line;
    while (getline(file, line)) {
        if (line.empty()) continue;

        vector<string> data = split(line, '|');

        if (data.size() == 7) {
            string id = data[0];
            string username = data[1];
            string password = data[2];
            string fullName = data[3];
            string phone = data[4];
            string location = data[5]; 
            
            int roleInt = stoi(data[6]);
            UserRole role = (roleInt == 0) ? ADMIN : USER; 

            UserDTO user(id, username, password, fullName, phone, location, role);
            users.push_back(user);
        }
    }
    file.close();
    return users;
}
//ghi danh sách user vào file
void UserDAL::writeUsers(const vector<UserDTO>& users) {
    ofstream file(FILE_PATH);

    if (file.is_open()) {
        for (const auto& user : users) {
            int roleInt = (user.getRole() == ADMIN) ? 0 : 1;

            file << user.getId() << "|"
                 << user.getUsername() << "|"
                 << user.getPassword() << "|"
                 << user.getFullName() << "|"
                 << user.getPhoneNumber() << "|"
                 << user.getLocation() << "|"  
                 << roleInt << "\n";
        }
        file.close();
    } else {
        cout << "Loi: Khong the mo file de ghi!\n";
    }
}