import 'package:flutter/material.dart';

class BackgroundPattern extends StatelessWidget {
  const BackgroundPattern({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_pattern.png'),
          repeat: ImageRepeat.repeat,
          fit: BoxFit.none,
        ),
      ),
    );
  }
}
