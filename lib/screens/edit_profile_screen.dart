import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../utils/app_colors.dart';

// Form for changing name, faculty and bio. Returns the updated profile to
// the Profile screen with Navigator.pop.
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
  late final TextEditingController _facultyController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    // Start the fields with the current values.
    _nameController = TextEditingController(text: widget.profile.name);
    _facultyController = TextEditingController(text: widget.profile.faculty);
    _bioController = TextEditingController(text: widget.profile.bio);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _facultyController.dispose();
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

  String? _validateFaculty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your faculty';
    }
    return null;
  }

  String? _validateBio(String? value) {
    if ((value ?? '').trim().length > _bioLimit) {
      return 'Keep your bio under $_bioLimit characters';
    }
    return null;
  }

  void _save() {
    // validate() shows the error text under every invalid field.
    if (!_formKey.currentState!.validate()) return;

    final updated = widget.profile.copyWith(
      name: _nameController.text.trim(),
      faculty: _facultyController.text.trim(),
      bio: _bioController.text.trim(),
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
                const _FieldLabel('Full name *'),
                TextFormField(
                  controller: _nameController,
                  textCapitalization: TextCapitalization.words,
                  validator: _validateName,
                  decoration: const InputDecoration(
                    hintText: 'Enter your full name',
                  ),
                ),
                const SizedBox(height: 20),
                const _FieldLabel('Faculty *'),
                TextFormField(
                  controller: _facultyController,
                  textCapitalization: TextCapitalization.words,
                  validator: _validateFaculty,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Engineering',
                  ),
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
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Save changes'),
                ),
              ],
            ),
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
