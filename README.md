# Thông tin sinh viên

MSSV: **24120098**
Họ và tên: *Nguyễn Quốc Nam*

# Ollama Server

#### Cài đặt Ollama

```Bash
curl -fsSL https://ollama.com/install.sh | sh
```

#### Cài đặt model (Gemma 3)

```Bash
ollama run gemma3:1b
```

**Build & run:** 

```bash
ollama serve
```


```bash
cd src/ai
ollama rm greenroute-helper
ollama create greenroute-helper -f Modelfile
```

# Backend Server

#### Cách 1: Dùng Docker

**Requirement:** Docker

**Build & run:** 

- Linux

```bash
docker build -t green-route .
docker run --rm -p 5000:5000 green_route
```

- Windows

  - Bật backend WSL hoặc Hyper-V trong Docker Desktop.

```powershell
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
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
./build/green_route
```

- Windows

  - Cài Visual Studio (MSVC) + CMake và các thư viện mongocxx/bsoncxx, OpenSSL, Asio bản Windows rồi thêm vào `CMAKE_PREFIX_PATH`.

```powershell
cmake -S . -B build -G "Visual Studio 17 2022" -DCMAKE_BUILD_TYPE=Release ^
      -DCMAKE_PREFIX_PATH="C:/mongo-cxx-driver;C:/OpenSSL-Win64"
cmake --build build --config Release
.\build\Release\green_route.exe
```

# App

**Requirement:** Flutter SDK

#### Cách 1: Chạy trên Flutter

```bash
cd src/ui
flutter run
```

#### Cách 2: Build thành app

- Linux: 
  - App tại src/ui/build/linux/x64/release/bundle/ui

```bash
cd src/ui
flutter build linux --release
```

- Windows: 
  - App tại src/ui/build/windows/x64/runner/Release/greenroute.exe

```bash
cd src/ui
flutter build windows --release
```
