import 'package:flutter/material.dart';

import '../components/auth_screen/title_field.dart';

/// Reusable tiled background for auth-related screens.
class BackgroundPattern extends StatelessWidget {
  const BackgroundPattern({super.key, this.showTitle = false});

  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bg_pattern.png'),
                  repeat: ImageRepeat.repeat,
                  fit: BoxFit.none,
                  alignment: Alignment.topLeft,
                  filterQuality: FilterQuality.none,
                ),
              ),
            ),
          ),
          if (showTitle)
            IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: const TitleField(),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
