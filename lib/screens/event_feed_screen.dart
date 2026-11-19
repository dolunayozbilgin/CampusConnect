import 'package:flutter/material.dart';

import '../data/sample_events.dart';
import '../models/campus_event.dart';
import '../utils/app_colors.dart';
import 'event_details_screen.dart';

class EventFeedScreen extends StatefulWidget {
  const EventFeedScreen({super.key});

  @override
  State<EventFeedScreen> createState() => _EventFeedScreenState();
}

class _EventFeedScreenState extends State<EventFeedScreen> {
  static const _categories = [
    'All',
    'Arts',
    'Social',
    'Sports',
    'Academic',
    'Volunteering',
  ];

  final _searchController = TextEditingController();
  int _tab = 0;
  String _category = 'All';
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CampusEvent> get _visible {
    final query = _query.trim().toLowerCase();
    return sampleEvents.where((event) {
      final categoryOk = _category == 'All' || event.category == _category;
      if (!categoryOk) return false;
      if (query.isEmpty) return true;
      return event.title.toLowerCase().contains(query) ||
          event.location.toLowerCase().contains(query);
    }).toList();
  }

  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _category = 'All';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Keep the feed phone-width on a desktop window so cards and covers
    // don't stretch into a thin strip.
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Scaffold(
          body: SafeArea(child: _tab == 0 ? _buildFeed() : _buildPlaceholder()),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _tab,
            onDestinationSelected: (index) => setState(() => _tab = index),
            backgroundColor: AppColors.surface,
            indicatorColor: AppColors.primaryLight,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Feed',
              ),
              NavigationDestination(
                icon: Icon(Icons.calendar_today_outlined),
                selectedIcon: Icon(Icons.calendar_today),
                label: 'My Events',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline),
                selectedIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final title = _tab == 1 ? 'My Events' : 'Profile';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          const Spacer(),
          const Center(
            child: Text(
              'This screen is next.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildFeed() {
    final events = _visible;
    final countLabel = events.length == 1
        ? '1 event'
        : '${events.length} events';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'Event Feed',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Create event is next')),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Create'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: TextField(
            controller: _searchController,
            onChanged: (value) => setState(() => _query = value),
            decoration: InputDecoration(
              hintText: 'Search campus events',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Filters are next')),
                  );
                },
                icon: const Icon(Icons.tune, size: 20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final name = _categories[index];
              final selected = name == _category;
              return ChoiceChip(
                label: Text(name),
                selected: selected,
                showCheckmark: false,
                visualDensity: VisualDensity.compact,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                labelStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                ),
                selectedColor: AppColors.primaryLight,
                backgroundColor: AppColors.surface,
                side: BorderSide(
                  color: selected ? AppColors.primaryLight : AppColors.border,
                ),
                onSelected: (_) => setState(() => _category = name),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
          child: Row(
            children: [
              const Text(
                'Campus events',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              Text(
                countLabel,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: events.isEmpty
              ? _EmptyFeed(onClear: _clearFilters)
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                  itemCount: events.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == events.length) {
                      return const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text(
                          "You're all caught up. Check back for more events.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }
                    return _EventCard(event: events[index]);
                  },
                ),
        ),
      ],
    );
  }
}

class _EmptyFeed extends StatelessWidget {
  const _EmptyFeed({required this.onClear});

  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 28, color: AppColors.textHint),
          const SizedBox(height: 12),
          const Text(
            'No events found',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text(
            'Try another search or clear your filters to see upcoming events.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onClear,
            child: const Text('Clear search & filters'),
          ),
        ],
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({required this.event});

  final CampusEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.surface,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => EventDetailsScreen(event: event)),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  height: 168,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _Cover(url: event.imageUrl),
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: _DateTile(day: event.day),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            event.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _Tag(
                          label: event.category,
                          background: AppColors.tagGreen,
                          foreground: AppColors.tagGreenText,
                        ),
                      ],
                    ),
                  ),
                  if (event.isFull) ...[
                    const Spacer(),
                    const _Tag(
                      label: 'Full',
                      background: AppColors.tagAmber,
                      foreground: AppColors.tagAmberText,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${formatEventDay(event.day)} · ${event.timeRange}',
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      event.location,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _Initials(initials: event.initials),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      '${event.going} / ${event.capacity} going',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
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

class _DateTile extends StatelessWidget {
  const _DateTile({required this.day});

  final DateTime day;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.cover,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            eventMonthLabel(day),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.tagGreenText,
            ),
          ),
          Text(
            '${day.day}',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _Cover extends StatelessWidget {
  const _Cover({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: 168,
      alignment: Alignment.center,
      errorBuilder: (_, _, _) {
        return const ColoredBox(
          color: AppColors.cover,
          child: Icon(
            Icons.photo_camera_outlined,
            color: AppColors.tagGreenText,
          ),
        );
      },
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}

class _Initials extends StatelessWidget {
  const _Initials({required this.initials});

  final List<String> initials;

  static const _colors = [
    Color(0xFFD9E4F5),
    Color(0xFFF8E3C8),
    Color(0xFFD8F0E3),
  ];

  @override
  Widget build(BuildContext context) {
    final shown = initials.take(3).toList();
    return SizedBox(
      width: shown.isEmpty ? 0 : 16.0 + (shown.length * 16),
      height: 26,
      child: Stack(
        children: [
          for (var i = 0; i < shown.length; i++)
            Positioned(
              left: i * 16,
              child: CircleAvatar(
                radius: 13,
                backgroundColor: AppColors.surface,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: _colors[i % _colors.length],
                  child: Text(
                    shown[i],
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
