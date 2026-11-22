import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class EventCover extends StatelessWidget {
  const EventCover({super.key, required this.url, this.height = 168});

  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: height,
      alignment: Alignment.center,
      errorBuilder: (_, _, _) {
        return const ColoredBox(
          color: AppColors.cover,
          child: Icon(
            Icons.photo_camera_outlined,
            color: AppColors.tagGreenText,
          ),
        );
      },
    );
  }
}
