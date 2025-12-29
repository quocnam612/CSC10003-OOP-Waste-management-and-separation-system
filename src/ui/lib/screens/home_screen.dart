import 'package:flutter/material.dart';
import 'package:ui/screens/manager_screen.dart';
import 'package:ui/screens/user_screen.dart';
import 'package:ui/screens/worker_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.userData, required this.authToken});

  final Map<String, dynamic> userData;
  final String authToken;

  @override
  Widget build(BuildContext context) {
    final int? resolvedRole = userData['role'];

    if (resolvedRole == 1) {
      return ResidentDashboard(userData: userData, authToken: authToken);
    }
    if (resolvedRole == 2) {
      return WorkerDashboard(userData: userData, authToken: authToken);
    }
    if (resolvedRole == 3) {
      return ManagerDashboard(userData: userData, authToken: authToken);
    }

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
}
