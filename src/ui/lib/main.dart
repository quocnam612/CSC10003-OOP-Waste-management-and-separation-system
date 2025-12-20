import 'package:flutter/material.dart';

// --- CẬP NHẬT IMPORT THEO CẤU TRÚC MỚI ---

// 1. AuthScreen giờ nằm trong features/auth/screens
import 'features/auth/screens/auth_screen.dart'; 

// 2. LoadScreen (Màn hình chờ)
// Khuyên bạn nên di chuyển file này vào 'features/auth/screens/' 
// hoặc 'shared/widgets/' để không còn folder 'screens' cũ nữa.
import 'features/auth/screens/load_screen.dart'; 
// Nếu chưa di chuyển, hãy đổi thành: import 'screens/load_screen.dart';

void main() {
  runApp(const WasteManagementApp());
}

class WasteManagementApp extends StatelessWidget {
  const WasteManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenRoute',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        // Định nghĩa màu sắc chủ đạo (Xanh lá)
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF13A05D),
          primary: const Color(0xFF13A05D),
          secondary: const Color(0xFF0A7443),
          brightness: Brightness.light,
        ),
        // Style chung cho các ô nhập liệu (Input)
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF13A05D), width: 1.5),
          ),
        ),
      ),
      // Màn hình khởi động đầu tiên
      home: const EntryShell(),
    );
  }
}

class EntryShell extends StatefulWidget {
  const EntryShell({super.key});

  @override
  State<EntryShell> createState() => _EntryShellState();
}

class _EntryShellState extends State<EntryShell> {
  // Trạng thái loading giả lập (3 giây đầu)
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    // 1. Nếu đang loading -> Hiển thị LoadScreen
    if (_isLoading) {
      return LoadScreen(
        onFinished: () {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        },
      );
    }

    // 2. Load xong -> Chuyển sang AuthScreen (Đăng nhập/Đăng ký)
    // AuthScreen sẽ tự điều hướng sang Dashboard tùy theo vai trò
    return const AuthScreen();
  }
}