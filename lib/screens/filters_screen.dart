import 'package:flutter/material.dart';

import '../data/filter_options.dart';
import '../models/event_filters.dart';
import '../utils/app_colors.dart';
import '../widgets/interest_chip.dart';
import '../widgets/outline_action_button.dart';

// Opened from the filter icon on the Event Feed. Apply returns the chosen
// filters with Navigator.pop; Reset clears every choice on this screen.
class FiltersScreen extends StatefulWidget {
  const FiltersScreen({super.key, this.initial = const EventFilters()});

  final EventFilters initial;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  static const _rangeLabels = {
    DateRange.any: 'Any date',
    DateRange.today: 'Today',
    DateRange.thisWeek: 'This week',
    DateRange.custom: 'Custom',
  };

  final _formKey = GlobalKey<FormState>();
  final _fromController = TextEditingController();
  final _toController = TextEditingController();

  late DateRange _range;
  DateTime? _from;
  DateTime? _to;
  late Set<String> _categories;
  String? _location;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _range = initial.range;
    _from = initial.from;
    _to = initial.to;
    _categories = {...initial.categories};
    _location = initial.location;
    _fromController.text = _format(_from);
    _toController.text = _format(_to);
  }

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  // 18/11/2026
  String _format(DateTime? day) {
    if (day == null) return '';
    final dd = day.day.toString().padLeft(2, '0');
    final mm = day.month.toString().padLeft(2, '0');
    return '$dd/$mm/${day.year}';
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _from : _to) ?? _from ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );
    if (picked == null) return;
    setState(() {
      if (isFrom) {
        _from = picked;
        _fromController.text = _format(picked);
      } else {
        _to = picked;
        _toController.text = _format(picked);
      }
    });
  }

  String? _validateFrom(String? _) {
    if (_range == DateRange.custom && _from == null) {
      return 'Pick a start date';
    }
    return null;
  }

  String? _validateTo(String? _) {
    if (_range != DateRange.custom) return null;
    if (_to == null) return 'Pick an end date';
    if (_from != null && _to!.isBefore(_from!)) {
      return 'End is before start';
    }
    return null;
  }

  void _toggleCategory(String category) {
    setState(() {
      if (!_categories.remove(category)) {
        _categories.add(category);
      }
    });
  }

  void _reset() {
    setState(() {
      _range = DateRange.any;
      _from = null;
      _to = null;
      _fromController.clear();
      _toController.clear();
      _categories.clear();
      _location = null;
    });
  }

  void _apply() {
    if (!_formKey.currentState!.validate()) return;
    final custom = _range == DateRange.custom;
    Navigator.pop(
      context,
      EventFilters(
        range: _range,
        from: custom ? _from : null,
        to: custom ? _to : null,
        categories: {..._categories},
        location: _location,
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
          'Filters',
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
                  'Find something that fits your schedule.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                const _SectionTitle('When'),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final entry in _rangeLabels.entries)
                      _RangeChip(
                        label: entry.value,
                        selected: _range == entry.key,
                        onTap: () => setState(() => _range = entry.key),
                      ),
                  ],
                ),
                // From / To only show for a custom range.
                if (_range == DateRange.custom) ...[
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _DateField(
                          label: 'From',
                          controller: _fromController,
                          validator: _validateFrom,
                          onTap: () => _pickDate(isFrom: true),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _DateField(
                          label: 'To',
                          controller: _toController,
                          validator: _validateTo,
                          onTap: () => _pickDate(isFrom: false),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Expanded(child: _SectionTitle('What are you into?')),
                    const Text(
                      'Select multiple',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    InterestChip(
                      label: 'All',
                      selected: _categories.isEmpty,
                      onTap: () => setState(_categories.clear),
                    ),
                    for (final category in filterCategories)
                      InterestChip(
                        label: category,
                        selected: _categories.contains(category),
                        onTap: () => _toggleCategory(category),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Location',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String?>(
                  // The key makes Reset rebuild the dropdown with no value.
                  key: ValueKey(_location),
                  initialValue: _location,
                  isExpanded: true,
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('All campus locations'),
                    ),
                    for (final location in campusLocations)
                      DropdownMenuItem<String?>(
                        value: location,
                        child: Text(location),
                      ),
                  ],
                  onChanged: (value) => setState(() => _location = value),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: _apply,
                child: const Text('Apply filters'),
              ),
              const SizedBox(height: 8),
              OutlineActionButton(label: 'Reset filters', onPressed: _reset),
            ],
          ),
        ),
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

// Blue single-choice chip used for the date range.
class _RangeChip extends StatelessWidget {
  const _RangeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primaryLight : AppColors.surface,
      shape: StadiumBorder(
        side: BorderSide(
          color: selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        customBorder: const StadiumBorder(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                const Icon(Icons.check, size: 14, color: AppColors.primary),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Read-only field that opens a date picker when tapped.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.controller,
    required this.validator,
    required this.onTap,
  });

  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          validator: validator,
          decoration: const InputDecoration(
            hintText: 'DD / MM / YYYY',
            suffixIcon: Icon(Icons.calendar_today_outlined, size: 18),
          ),
        ),
      ],
    );
  }
}
