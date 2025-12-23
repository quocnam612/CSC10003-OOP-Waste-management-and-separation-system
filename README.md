# CSC10003-OOP-Waste-management-and-separation-system

## Requirement

* C++23
* Mongodb ([C++ driver](https://www.mongodb.com/docs/languages/cpp/cpp-driver/current/get-started/#std-label-cpp-get-started))
* [Flutter](https://docs.flutter.dev/install/with-vs-code)
* CMake

## Run & Build Backend

* Configuration

    ```
    cmake -S . -B build
    ```

* Build

    ```
    cmake --build build
    ```

* Run

    ```
    ./out/greenroute
    ```

## Run & Debug Frontend

You can either go to `src/ui/lib/main.dart` and choose Run/Debug or:

* Run

  ```
  cd src/ui
  flutter run
  ```
