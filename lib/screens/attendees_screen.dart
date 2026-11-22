import 'package:flutter/material.dart';

import '../data/sample_people.dart';
import '../models/campus_event.dart';
import '../models/student.dart';
import '../utils/app_colors.dart';
import '../widgets/initials_avatar.dart';

class AttendeesScreen extends StatelessWidget {
  const AttendeesScreen({
    super.key,
    required this.event,
    required this.going,
    required this.includesMe,
  });

  final CampusEvent event;
  // Live count from the details screen (it changes when you join/leave).
  final int going;
  // True when you organize or joined, so you are one of [going].
  final bool includesMe;

  @override
  Widget build(BuildContext context) {
    final othersGoing = includesMe ? going - 1 : going;
    final others = sampleStudents
        .take(othersGoing.clamp(0, sampleStudents.length))
        .toList();
    final shown = others.length + (includesMe ? 1 : 0);

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'Attendees',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cover,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 16,
                        color: AppColors.tagGreenText,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '$going going · Capacity ${event.capacity}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.tagGreenText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (shown == 0)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'No one has joined yet.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: [
                    if (includesMe)
                      _AttendeeRow(
                        name: 'You',
                        subtitle: event.isOrganizer ? 'Organizer' : 'Going',
                        tag: event.isOrganizer ? 'Organizer · You' : 'You',
                      ),
                    for (var i = 0; i < others.length; i++) ...[
                      if (i > 0 || includesMe)
                        const Divider(
                          height: 1,
                          indent: 16,
                          endIndent: 16,
                          color: AppColors.border,
                        ),
                      _AttendeeRow.student(others[i]),
                    ],
                  ],
                ),
              ),
            if (shown < going) ...[
              const SizedBox(height: 14),
              Text(
                'Showing $shown of $going attendees',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AttendeeRow extends StatelessWidget {
  const _AttendeeRow({required this.name, required this.subtitle, this.tag});

  _AttendeeRow.student(Student student)
    : name = student.name,
      subtitle = student.subtitle,
      tag = null;

  final String name;
  final String subtitle;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          InitialsAvatar(name: name),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (tag != null)
            Text(
              tag!,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.tagGreenText,
              ),
            ),
        ],
      ),
    );
  }
}
