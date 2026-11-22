import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../utils/app_colors.dart';

class EventDateTile extends StatelessWidget {
  const EventDateTile({super.key, required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.cover,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            eventMonthLabel(day),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.tagGreenText,
            ),
          ),
          Text(
            '${day.day}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
