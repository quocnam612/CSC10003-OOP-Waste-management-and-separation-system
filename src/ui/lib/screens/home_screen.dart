import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        leading: Icon(
            Icons.eco,
            size: 40,
            color: Colors.white,
          ),
        title: const Text('GreenRoute'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.eco,
              size: 72,
              color: primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Chào mừng bạn đến với GreenRoute!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Bắt đầu quản lý hành trình rác thải của bạn từ đây.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
