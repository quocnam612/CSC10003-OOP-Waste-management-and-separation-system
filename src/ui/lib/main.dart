import 'package:flutter/material.dart';

import 'screens/auth_screen.dart';
import 'screens/load_screen.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF13A05D),
          primary: const Color(0xFF13A05D),
          secondary: const Color(0xFF0A7443),
          brightness: Brightness.light,
        ),
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
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return LoadScreen(
        onFinished: () {
          if (mounted) {
            setState(() => _isLoading = false);
          }
        },
      );
    }

    return const AuthScreen();
  }
}
