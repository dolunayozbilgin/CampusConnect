import 'package:flutter/material.dart';

import '../models/campus_event.dart';
import '../utils/app_colors.dart';
import '../widgets/event_cover.dart';
import '../widgets/event_date_tile.dart';
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

  bool get _isFull => _going >= widget.event.capacity;

  void _showComingSoon(String screen) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('$screen screen is coming soon')));
  }

  // "Photography Society" -> "PS"
  String _initialsOf(String name) {
    return name.split(' ').take(2).map((word) => word[0]).join();
  }

  void _toggleJoin() {
    setState(() {
      _joined = !_joined;
      _going += _joined ? 1 : -1;
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            _joined
                ? 'You joined ${widget.event.title}'
                : 'You left ${widget.event.title}',
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'Event Details',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
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
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      EventCover(url: event.imageUrl, height: 200),
                      Positioned(
                        left: 12,
                        top: 12,
                        child: EventDateTile(day: event.day),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  EventTag(
                    label: event.category.toUpperCase(),
                    background: AppColors.tagGreen,
                    foreground: AppColors.tagGreenText,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                event.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                event.description,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    _InfoRow(
                      icon: Icons.calendar_today_outlined,
                      text: formatEventDay(event.day),
                      subtitle: event.timeRange,
                    ),
                    _InfoRow(
                      icon: Icons.location_on_outlined,
                      text: event.location,
                    ),
                    _InfoRow(
                      icon: Icons.people_outline,
                      text: '$_going / ${event.capacity} going',
                      trailing: EventTag(
                        label: _isFull
                            ? 'Full'
                            : '${event.capacity - _going} spots left',
                        background: AppColors.tagAmber,
                        foreground: AppColors.tagAmberText,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.tagGreen,
                    child: Text(
                      _initialsOf(event.host),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.tagGreenText,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Organized by',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          event.host,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _LinkRow(
                icon: Icons.people_outline,
                label: 'Attendees',
                value: '$_going going',
                onTap: () => _showComingSoon('Attendees'),
              ),
              const SizedBox(height: 10),
              _LinkRow(
                icon: Icons.chat_bubble_outline,
                label: 'Discussion',
                onTap: () => _showComingSoon('Discussion'),
              ),
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
                  onPressed: _isFull ? null : _toggleJoin,
                  icon: Icon(_isFull ? Icons.block : Icons.add, size: 18),
                  label: Text(_isFull ? 'Event is full' : 'Join event'),
                ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    this.subtitle,
    this.trailing,
  });

  final IconData icon;
  final String text;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (value != null)
                Text(
                  value!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
