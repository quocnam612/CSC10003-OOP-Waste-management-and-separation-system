cmake_minimum_required(VERSION 3.10)
project(CSC10003_OOP_FINAL)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

find_package(mongocxx REQUIRED)
find_package(bsoncxx REQUIRED)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/bin)

add_executable(CSC10003_OOP_FINAL src/main.cpp)

target_link_directories()