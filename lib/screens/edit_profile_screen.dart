import 'package:flutter/material.dart';

import '../data/sample_profile.dart';
import '../models/user_profile.dart';
import '../utils/app_colors.dart';
import '../widgets/interest_chip.dart';
import '../widgets/outline_action_button.dart';
import '../widgets/profile_avatar.dart';

// Form for changing photo, name, faculty, year, bio and interests. The
// university email is read-only. Returns the updated profile to the
// Profile screen with Navigator.pop.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const _bioLimit = 150;

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;
  late String _faculty;
  late int _year;
  late Set<String> _interests;
  bool _showInterestError = false;

  @override
  void initState() {
    super.initState();
    // Start every field with the current values.
    final profile = widget.profile;
    _nameController = TextEditingController(text: profile.name);
    _bioController = TextEditingController(text: profile.bio);
    _faculty = profile.faculty;
    _year = profile.year;
    _interests = {...profile.interests};
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final name = value?.trim() ?? '';
    if (name.isEmpty) {
      return 'Enter your full name';
    }
    if (name.length < 2) {
      return 'Name is too short';
    }
    return null;
  }

  String? _validateBio(String? value) {
    if ((value ?? '').trim().length > _bioLimit) {
      return 'Keep your bio under $_bioLimit characters';
    }
    return null;
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (!_interests.remove(interest)) {
        _interests.add(interest);
      }
      if (_interests.isNotEmpty) _showInterestError = false;
    });
  }

  void _showPhotoMessage() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Photo upload comes with Firebase')),
      );
  }

  void _save() {
    // validate() shows the error text under every invalid field.
    final fieldsOk = _formKey.currentState!.validate();
    setState(() => _showInterestError = _interests.isEmpty);
    if (!fieldsOk || _interests.isEmpty) return;

    final updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      faculty: _faculty,
      year: _year,
      bio: _bioController.text.trim(),
      // Keep the order of the option list, not the order of taps.
      interests: profileInterests.where(_interests.contains).toList(),
    );

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Profile updated'),
        content: const Text('Your changes have been saved.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              Navigator.pop(context, updated);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.profile;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        titleSpacing: 0,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        backgroundColor: AppColors.background,
        scrolledUnderElevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Photo row
                Row(
                  children: [
                    ProfileAvatar(name: profile.name, radius: 20),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: _showPhotoMessage,
                      child: const Text('Change photo'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: _showPhotoMessage,
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.textSecondary,
                      ),
                      child: const Text('Remove photo'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                const _FieldLabel('Full name *'),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  validator: _validateName,
                  decoration: const InputDecoration(
                    hintText: 'Name and surname',
                  ),
                ),
                const SizedBox(height: 20),

                // Email comes from the university account, so it is locked.
                const _FieldLabel('University email *'),
                TextFormField(
                  initialValue: profile.email,
                  readOnly: true,
                  enabled: false,
                  style: const TextStyle(color: AppColors.textSecondary),
                  decoration: const InputDecoration(
                    fillColor: AppColors.background,
                    suffixIcon: Icon(Icons.lock_outline, size: 18),
                  ),
                ),
                const SizedBox(height: 20),

                // Faculty and year side by side; Expanded shares the width
                // so the dropdowns never overflow on small phones.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _FieldLabel('Faculty *'),
                          DropdownButtonFormField<String>(
                            initialValue: _faculty,
                            isExpanded: true,
                            items: [
                              for (final faculty in profileFaculties)
                                DropdownMenuItem(
                                  value: faculty,
                                  child: Text(faculty),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _faculty = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const _FieldLabel('Year of study *'),
                          DropdownButtonFormField<int>(
                            initialValue: _year,
                            isExpanded: true,
                            items: [
                              for (final year in profileYears)
                                DropdownMenuItem(
                                  value: year,
                                  child: Text('Year $year'),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() => _year = value);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                const _FieldLabel('Bio'),
                TextFormField(
                  controller: _bioController,
                  validator: _validateBio,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'Tell others what you are into',
                  ),
                ),
                const SizedBox(height: 20),

                const _FieldLabel('Interests · Select all that apply'),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final interest in profileInterests)
                      InterestChip(
                        label: interest,
                        selected: _interests.contains(interest),
                        onTap: () => _toggleInterest(interest),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  _showInterestError
                      ? 'Select at least one interest'
                      : '${_interests.length} selected',
                  style: TextStyle(
                    fontSize: 12,
                    color: _showInterestError
                        ? AppColors.error
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            border: Border(top: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            children: [
              Expanded(
                child: OutlineActionButton(
                  label: 'Cancel',
                  onPressed: () => Navigator.maybePop(context),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: FilledButton(
                  onPressed: _save,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                  ),
                  child: const Text('Save profile'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }
}
