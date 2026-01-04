# Backend Server

#### Cách 1: Dùng Docker

**Requirement:** Docker

**Build & run:** 

- Linux

```bash
cd source
docker build -t green-route .
docker run --rm -p 5000:5000 green_route
```

- Windows

  - Bật backend WSL hoặc Hyper-V trong Docker Desktop.

```powershell
cd source
docker build -t green-route .
docker run --rm -p 5000:5000 green_route
```


#### Cách 2: Dùng CMake

**Requirement:**

- C++23
- CMake
- Asio C++ Library
- Mongocxx (Mongodb c++ driver)
- OpenSSL Library

**Build & run:** 

- Linux

```bash
cd source
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
./build/green_route
```

- Windows

  - Cài Visual Studio (MSVC) + CMake và các thư viện mongocxx/bsoncxx, OpenSSL, Asio bản Windows rồi thêm vào `CMAKE_PREFIX_PATH`.

```powershell
cd source
cmake -S . -B build -G "Visual Studio 17 2022" -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH="C:/mongo-cxx-driver;C:/OpenSSL-Win64"
cmake --build build --config Release
.\build\Release\green_route.exe
```

# App

**Requirement:** Flutter SDK

#### Cách 1: Chạy trên Flutter

- Nếu tự host backend

```bash
cd source/src/ui
flutter run
```

- Nếu dùng server có sẵn trên Render (có thể chậm khi lần đầu dùng do server phải khởi động sau khi sleep)

```bash
cd source/src/ui
flutter run --dart-define=API_URL=https://csc10003-oop-waste-management-and.onrender.com
```

#### Cách 2: Build thành app

- Linux: 
  - App tại source/src/ui/build/linux/x64/release/bundle/ui

```bash
cd source/src/ui
flutter build linux --release
```

- Windows: 
  - App tại source/src/ui/build/windows/x64/runner/Release/greenroute.exe

```bash
cd source/src/ui
flutter build windows --release
```
