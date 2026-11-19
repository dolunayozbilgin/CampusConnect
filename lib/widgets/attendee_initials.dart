import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class AttendeeInitials extends StatelessWidget {
  const AttendeeInitials({super.key, required this.initials});

  final List<String> initials;

  static const _colors = [
    Color(0xFFD9E4F5),
    Color(0xFFF8E3C8),
    Color(0xFFD8F0E3),
  ];

  @override
  Widget build(BuildContext context) {
    final shown = initials.take(3).toList();
    return SizedBox(
      width: shown.isEmpty ? 0 : 16.0 + (shown.length * 16),
      height: 26,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * 16,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: AppColors.surface,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: _colors[i % _colors.length],
                  child: Text(
                    shown[i],
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
