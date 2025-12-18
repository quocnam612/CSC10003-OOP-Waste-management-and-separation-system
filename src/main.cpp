#include <iostream>
#include "bus/auth_service.h"

int main() {
    // Example usage of the auth_service functions
    auto regResult = registerUser(2, "testuser", "password123", "1234567890", "Test User", 1);
    if (regResult) {
        std::cout << "User registered successfully.\n";
    } else {
        std::cout << "Registration failed: " << regResult.error() << "\n";
    }
    
  return 0;
}