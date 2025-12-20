import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../widgets/background_pattern.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({super.key, this.onFinished});

  final VoidCallback? onFinished;

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Simulate a loading delay then notify the parent that loading finished.
    Timer(const Duration(seconds: 2), () {
      widget.onFinished?.call();
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundPattern(),
          Center(
            child: RotationTransition(
              turns: _rotationController,
              child: SvgPicture.asset(
                'assets/icons/loading.svg',
                width: 48,
                height: 48,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
