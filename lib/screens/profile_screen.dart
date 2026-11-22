import 'package:flutter/material.dart';

import '../data/sample_profile.dart';
import '../models/user_profile.dart';
import '../utils/app_colors.dart';
import '../widgets/event_tag.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/stat_tile.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';

// Shown inside the "Profile" tab of the bottom navigation, so it has no
// Scaffold of its own.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile _profile = sampleProfile;
  bool _notifications = true;

  Future<void> _openEditProfile() async {
    final updated = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(profile: _profile)),
    );
    // null means the user went back without saving.
    if (updated != null) {
      setState(() => _profile = updated);
    }
  }

  void _confirmLogOut() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to log in again to see events.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              // Clear the whole stack so Back can't return to the app.
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              TextButton.icon(
                onPressed: _openEditProfile,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: 8),
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
          const SizedBox(height: 24),
          const _SectionTitle('Interests'),
          const SizedBox(height: 10),
          // Wrap moves chips to the next line instead of overflowing.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final interest in _profile.interests)
                EventTag(
                  label: interest,
                  background: AppColors.primaryLight,
                  foreground: AppColors.primary,
                ),
            ],
          ),
          const SizedBox(height: 24),
          const _SectionTitle('Settings'),
          const SizedBox(height: 10),
          // Material (not a coloured Container) so the ListTile tap ripple
          // stays visible.
          Material(
            color: AppColors.surface,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.border),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: _notifications,
                  onChanged: (value) => setState(() => _notifications = value),
                  secondary: const Icon(Icons.notifications_outlined),
                  title: const Text('Event reminders'),
                ),
                const Divider(height: 1, color: AppColors.border),
                ListTile(
                  onTap: _confirmLogOut,
                  leading: const Icon(Icons.logout, color: AppColors.error),
                  title: const Text(
                    'Log out',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
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
