import 'package:flutter/material.dart';

import '../data/sample_profile.dart';
import '../models/user_profile.dart';
import '../utils/app_colors.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/stat_tile.dart';

// Shown inside the "Profile" tab of the bottom navigation, so it has no
// Scaffold of its own.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile _profile = sampleProfile;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _ProfileHeader(profile: _profile),
          const SizedBox(height: 12),
          // Three equal boxes that share the row on any screen width.
          Row(
            children: [
              Expanded(
                child: StatTile(value: _profile.joinedCount, label: 'Joined'),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  value: _profile.organizedCount,
                  label: 'Organized',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: StatTile(
                  value: _profile.interests.length,
                  label: 'Interests',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProfileAvatar(name: profile.name),
              const SizedBox(width: 14),
              // Expanded keeps long names from overflowing on small phones.
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.subtitle,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      profile.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            profile.bio,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
