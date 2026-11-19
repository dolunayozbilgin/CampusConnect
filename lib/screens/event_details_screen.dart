import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../utils/app_colors.dart';
import '../widgets/attendee_initials.dart';
import '../widgets/event_cover.dart';
import '../widgets/event_tag.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.event});

  final CampusEvent event;

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _joined = false;
  late int _going;

  @override
  void initState() {
    super.initState();
    _going = widget.event.going;
  }

  void _toggleJoin() {
    setState(() {
      _joined = !_joined;
      _going += _joined ? 1 : -1;
    });
  }

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
              const SizedBox(height: 20),
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                text: formatEventDay(event.day),
              ),
              _InfoRow(icon: Icons.schedule, text: event.timeRange),
              _InfoRow(icon: Icons.location_on_outlined, text: event.location),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(
                        event.host[0],
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hosted by',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            event.host,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'About this event',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  const Text(
                    'Attendees',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  Text(
                    '$_going / ${event.capacity} going',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: _going / event.capacity,
                  minHeight: 6,
                  backgroundColor: AppColors.border,
                  color: event.isFull
                      ? AppColors.tagAmberText
                      : AppColors.primary,
                ),
              ),
              const SizedBox(height: 12),
              AttendeeInitials(initials: event.initials),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: _joined
              ? OutlinedButton.icon(
                  onPressed: _toggleJoin,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text('Joined · Leave'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )
              : FilledButton.icon(
                  onPressed: _toggleJoin,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Join event'),
                ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
