import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

// "Dolunay Özbilgin" -> "DÖ"
String initialsOf(String name) {
  return name
      .split(' ')
      .where((word) => word.isNotEmpty)
      .take(2)
      .map((word) => word[0].toUpperCase())
      .join();
}

class InitialsAvatar extends StatelessWidget {
  const InitialsAvatar({super.key, required this.name, this.radius = 20});

  final String name;
  final double radius;

  // Background / text pairs; a name always gets the same pair.
  static const _palette = [
    (Color(0xFFE5F6EC), AppColors.tagGreenText),
    (Color(0xFFFCE4EC), Color(0xFFB0306A)),
    (Color(0xFFFFF4D6), AppColors.tagAmberText),
    (Color(0xFFE3ECFA), AppColors.primary),
    (Color(0xFF3D5A80), Colors.white),
  ];

  @override
  Widget build(BuildContext context) {
    final sum = name.codeUnits.fold<int>(0, (a, b) => a + b);
    final (background, foreground) = _palette[sum % _palette.length];
    return CircleAvatar(
      radius: radius,
      backgroundColor: background,
      child: Text(
        initialsOf(name),
        style: TextStyle(
          fontSize: radius * 0.6,
          fontWeight: FontWeight.w700,
          color: foreground,
        ),
      ),
    );
  }
}
