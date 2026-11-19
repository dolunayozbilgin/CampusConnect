import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../utils/app_colors.dart';
import '../widgets/event_cover.dart';
import '../widgets/event_tag.dart';


class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.event});

  final CampusEvent event;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: EventCover(url: event.imageUrl, height: 220),
              ),
              const SizedBox(height: 20),
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  EventTag(
                    label: event.category,
                    background: AppColors.tagGreen,
                    foreground: AppColors.tagGreenText,
                  ),
                  if (event.isFull) ...[
                    const SizedBox(width: 8),
                    const EventTag(
                      label: 'Full',
                      background: AppColors.tagAmber,
                      foreground: AppColors.tagAmberText,
                    ),
                  ],
                ],
              ),
            ],

          ),
        ),
      ),
    );
  }
}
