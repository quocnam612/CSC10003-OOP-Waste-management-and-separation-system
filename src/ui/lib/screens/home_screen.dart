import 'package:flutter/material.dart';
import 'package:ui/screens/manager_screen.dart';
import 'package:ui/screens/user_screen.dart';
import 'package:ui/screens/worker_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.userData});

  final Map<String, dynamic> userData;

  @override
  Widget build(BuildContext context) {
    final int? resolvedRole = _resolveRole(userData['role']);

    if (resolvedRole == 1) return const ResidentDashboard();
    if (resolvedRole == 2) return const WorkerDashboard();
    if (resolvedRole == 3) return const ManagerDashboard();

    return Scaffold(
      appBar: AppBar(
        title: const Text('GreenRoute'),
      ),
      body: Center(
        child: Text(
          'Không xác định được vai trò người dùng.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }

  int? _resolveRole(dynamic role) {
    if (role is int) return role;
    if (role is double) return role.toInt();
    if (role is String) {
      switch (role.toLowerCase()) {
        case '1':
        case 'user':
        case 'resident':
        case 'người dân':
          return 1;
        case '2':
        case 'worker':
        case 'operator':
        case 'nhân viên thu gom':
          return 2;
        case '3':
        case 'manager':
        case 'quản lý':
        case 'quản lý khu vực':
          return 3;
      }
    }
    return null;
  }
}
