import 'package:flutter/material.dart';

import '../data/sample_events.dart';
import '../models/campus_event.dart';
import '../utils/app_colors.dart';
import 'event_details_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  static const _categories = [
    'Arts',
    'Social',
    'Sports',
    'Academic',
    'Volunteering',
  ];
  static const _locations = ['FENS', 'FASS', 'FMAN', 'IC', 'UC', 'Other'];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController();
  final _locationDetailsController = TextEditingController();
  final _dateController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  String? _category;
  String? _location;
  DateTime? _date;
  TimeOfDay? _start;
  TimeOfDay? _end;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    _locationDetailsController.dispose();
    _dateController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  // Anything typed or picked counts as an unsaved change.
  bool get _hasChanges {
    final texts = [
      _titleController,
      _descriptionController,
      _capacityController,
      _locationDetailsController,
    ];
    return texts.any((c) => c.text.trim().isNotEmpty) ||
        _category != null ||
        _location != null ||
        _date != null ||
        _start != null ||
        _end != null;
  }

  String _two(int n) => n.toString().padLeft(2, '0');
  String _formatTime(TimeOfDay t) => '${_two(t.hour)}:${_two(t.minute)}';
  String _formatDate(DateTime d) =>
      '${_two(d.day)} / ${_two(d.month)} / ${d.year}';

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, 12, 31),
    );
    if (picked == null) return;
    setState(() {
      _date = picked;
      _dateController.text = _formatDate(picked);
    });
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: (isStart ? _start : _end) ?? TimeOfDay.now(),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isStart) {
        _start = picked;
        _startController.text = _formatTime(picked);
      } else {
        _end = picked;
        _endController.text = _formatTime(picked);
      }
    });
  }

  String? _required(String? value, String message) {
    if (value == null || value.trim().isEmpty) return message;
    return null;
  }

  String? _validateCapacity(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter a capacity';
    final number = int.tryParse(text);
    if (number == null || number < 1) return 'Use a whole number above 0';
    return null;
  }

  String? _validateEndTime(String? value) {
    if (_end == null) return 'Pick an end time';
    // Start-time errors are shown on their own field.
    if (_start == null) return null;
    final startMinutes = _start!.hour * 60 + _start!.minute;
    final endMinutes = _end!.hour * 60 + _end!.minute;
    if (endMinutes <= startMinutes) return 'End must be after start';
    return null;
  }

  void _publish() {
    if (!_formKey.currentState!.validate()) return;

    final details = _locationDetailsController.text.trim();
    final event = CampusEvent(
      title: _titleController.text.trim(),
      category: _category!,
      day: _date!,
      timeRange: '${_formatTime(_start!)}–${_formatTime(_end!)}',
      location: details.isEmpty ? _location! : '$_location, $details',
      going: 0,
      capacity: int.parse(_capacityController.text.trim()),
      imageUrl: '',
      initials: const [],
      description: _descriptionController.text.trim(),
      host: 'You',
    );
    sampleEvents.insert(0, event);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('Event published')));
  }

  Future<void> _confirmDiscard() async {
    final discard = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Discard this event?'),
        content: const Text('What you entered will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    if (discard == true && mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmDiscard();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          titleSpacing: 0,
          title: const Text(
            'Create Event',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          backgroundColor: AppColors.background,
          scrolledUnderElevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Bring your campus together · * Required fields',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  const _Label('Event title *'),
                  TextFormField(
                    controller: _titleController,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                    validator: (v) => _required(v, 'Give your event a name'),
                    decoration: const InputDecoration(
                      hintText: 'Give your event a name',
                    ),
                  ),
                  const SizedBox(height: 16),

                  const _Label('Description *'),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 3,
                    maxLines: 5,
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) => setState(() {}),
                    validator: (v) => _required(v, 'Add a short description'),
                    decoration: const InputDecoration(
                      hintText: 'What should students know?',
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _Label('Category *'),
                            DropdownButtonFormField<String>(
                              initialValue: _category,
                              isExpanded: true,
                              hint: const Text('Select category'),
                              items: [
                                for (final c in _categories)
                                  DropdownMenuItem(value: c, child: Text(c)),
                              ],
                              onChanged: (v) => setState(() => _category = v),
                              validator: (v) =>
                                  v == null ? 'Pick a category' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _Label('Date *'),
                            TextFormField(
                              controller: _dateController,
                              readOnly: true,
                              onTap: _pickDate,
                              validator: (_) =>
                                  _date == null ? 'Pick a date' : null,
                              decoration: const InputDecoration(
                                hintText: 'DD / MM / YYYY',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _Label('Start time *'),
                            TextFormField(
                              controller: _startController,
                              readOnly: true,
                              onTap: () => _pickTime(isStart: true),
                              validator: (_) =>
                                  _start == null ? 'Pick a start time' : null,
                              decoration: const InputDecoration(
                                hintText: 'HH : MM',
                                suffixIcon: Icon(Icons.schedule, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _Label('End time *'),
                            TextFormField(
                              controller: _endController,
                              readOnly: true,
                              onTap: () => _pickTime(isStart: false),
                              validator: _validateEndTime,
                              decoration: const InputDecoration(
                                hintText: 'HH : MM',
                                suffixIcon: Icon(Icons.schedule, size: 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _Label('Location *'),
                            DropdownButtonFormField<String>(
                              initialValue: _location,
                              isExpanded: true,
                              hint: const Text('Select campus location'),
                              items: [
                                for (final l in _locations)
                                  DropdownMenuItem(value: l, child: Text(l)),
                              ],
                              onChanged: (v) => setState(() => _location = v),
                              validator: (v) =>
                                  v == null ? 'Pick a location' : null,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const _Label('Capacity *'),
                            TextFormField(
                              controller: _capacityController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              validator: _validateCapacity,
                              decoration: const InputDecoration(
                                hintText: 'e.g. 20',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  const _Label('Location details'),
                  TextFormField(
                    controller: _locationDetailsController,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText: 'e.g. Room 204 (optional)',
                    ),
                  ),
                  const SizedBox(height: 16),

                  const _Label('Cover image (optional)'),
                  _UploadCoverTile(
                    onTap: () {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('Cover upload is coming soon'),
                          ),
                        );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: FilledButton.icon(
              onPressed: _publish,
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('Publish event'),
            ),
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

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

class _UploadCoverTile extends StatelessWidget {
  const _UploadCoverTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 22,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload cover image',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'JPG or PNG · Optional',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
