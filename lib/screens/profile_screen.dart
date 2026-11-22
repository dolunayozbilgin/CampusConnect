import 'package:flutter/material.dart';

import '../data/sample_profile.dart';
import '../models/user_profile.dart';
import '../utils/app_colors.dart';
import '../widgets/interest_chip.dart';
import '../widgets/outline_action_button.dart';
import '../widgets/profile_avatar.dart';
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
          const Text(
            'Profile',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _ProfileCard(profile: _profile, onEdit: _openEditProfile),
          const SizedBox(height: 24),
          const _SectionTitle('About me'),
          const SizedBox(height: 8),
          Text(
            _profile.bio.isEmpty ? 'No bio yet.' : _profile.bio,
            style: const TextStyle(
              fontSize: 14,
              height: 1.45,
              color: AppColors.textSecondary,
            ),
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
                InterestChip(label: interest),
            ],
          ),
          const SizedBox(height: 28),
          OutlineActionButton(
            label: 'Log out',
            icon: Icons.logout,
            onPressed: _confirmLogOut,
          ),
          const SizedBox(height: 12),
          const Text(
            'Your profile is visible to other campus students.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
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

// White card at the top: avatar, name, email, faculty tag, Edit profile.
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({required this.profile, required this.onEdit});

  final UserProfile profile;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          ProfileAvatar(name: profile.name, radius: 36),
          const SizedBox(height: 12),
          Text(
            profile.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            profile.email,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.school_outlined,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    profile.subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlineActionButton(
            label: 'Edit profile',
            icon: Icons.edit_outlined,
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }
}
