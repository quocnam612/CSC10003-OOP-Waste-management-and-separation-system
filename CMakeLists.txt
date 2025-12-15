cmake_minimum_required(VERSION 3.25)

project(green_route LANGUAGES CXX)

# ===============================
# C++23 Setup (Đây là phần quan trọng nhất để sửa lỗi expected)
# ===============================
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
add_compile_options(-std=c++23)

# ===============================
# MongoDB Configuration - TẠM THỜI TẮT (COMMENT OUT)
# ===============================
# set(MONGO_INSTALL_PATH "C:/path/to/mongo-cxx-driver") # <-- Dòng gây lỗi
# list(APPEND CMAKE_PREFIX_PATH ${MONGO_INSTALL_PATH})

# find_package(bsoncxx CONFIG REQUIRED)  <-- Tắt dòng này
# find_package(mongocxx CONFIG REQUIRED) <-- Tắt dòng này
# find_package(OpenSSL REQUIRED)         <-- Tắt dòng này

# ===============================
# Source files & Executable
# ===============================
file(GLOB_RECURSE project_sources CONFIGURE_DEPENDS "${CMAKE_SOURCE_DIR}/src/*.cpp")
list(FILTER project_sources EXCLUDE REGEX "/src/ui/")

add_executable(green_route ${project_sources})

# ===============================
# Link libraries - TẠM THỜI TẮT PHẦN MONGO
# ===============================
# target_link_libraries(green_route PRIVATE
#    mongocxx::mongocxx_shared
#    bsoncxx::bsoncxx_shared
#    OpenSSL::Crypto
# )

# ===============================
# Warnings
# ===============================
if (MSVC)
    target_compile_options(green_route PRIVATE /W4)
else()
    target_compile_options(green_route PRIVATE -Wall -Wextra -pedantic)
endif()