cmake_minimum_required(VERSION 3.16)
project(green_route LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)

list(APPEND CMAKE_PREFIX_PATH
    "/usr/local/lib/cmake/mongocxx"
    "/usr/local/lib/cmake/bsoncxx"
)

# Try to use the CMake config files if available, otherwise fall back to manual linking.
find_package(bsoncxx CONFIG)
find_package(mongocxx CONFIG)
find_package(OpenSSL REQUIRED)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/out)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/out)

# Collect backend sources but skip the Flutter UI tree, which has its own build.
file(GLOB_RECURSE project_sources CONFIGURE_DEPENDS "${CMAKE_SOURCE_DIR}/src/*.cpp")
list(FILTER project_sources EXCLUDE REGEX "/src/ui/")
add_executable(green_route ${project_sources})

if(TARGET bsoncxx::bsoncxx AND TARGET mongocxx::mongocxx)
    target_link_libraries(green_route PRIVATE
        bsoncxx::bsoncxx
        mongocxx::mongocxx
        OpenSSL::Crypto
    )
else()
    message(WARNING "Using manual include/library paths for bsoncxx/mongocxx.")
    target_include_directories(green_route PRIVATE
        /usr/local/include/mongocxx/v_noabi
        /usr/local/include/bsoncxx/v_noabi
    )
    target_link_libraries(green_route PRIVATE
        /usr/local/lib/libbsoncxx.so
        /usr/local/lib/libmongocxx.so
        OpenSSL::Crypto
    )
xx.so()
