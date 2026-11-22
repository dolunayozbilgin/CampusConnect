class CampusEvent {
  const CampusEvent({
    required this.id,
    required this.title,
    required this.category,
    required this.day,
    required this.timeRange,
    required this.location,
    required this.going,
    required this.capacity,
    required this.imageUrl,
    required this.initials,
    required this.description,
    required this.host,
    this.isOrganizer = false,
    this.isCancelled = false,
  });

  // Stays the same through edits, so comments can be keyed by it.
  final String id;
  final String title;
  final String category;
  final DateTime day;
  final String timeRange;
  final String location;
  final int going;
  final int capacity;
  final String imageUrl;
  final String description;
  final String host;
  final List<String> initials;
  // True when the signed-in student created this event.
  final bool isOrganizer;
  final bool isCancelled;

  bool get isFull => going >= capacity;

  CampusEvent copyWith({
    String? title,
    String? category,
    DateTime? day,
    String? timeRange,
    String? location,
    int? capacity,
    String? imageUrl,
    String? description,
    bool? isCancelled,
  }) {
    return CampusEvent(
      id: id,
      title: title ?? this.title,
      category: category ?? this.category,
      day: day ?? this.day,
      timeRange: timeRange ?? this.timeRange,
      location: location ?? this.location,
      going: going,
      capacity: capacity ?? this.capacity,
      imageUrl: imageUrl ?? this.imageUrl,
      initials: initials,
      description: description ?? this.description,
      host: host,
      isOrganizer: isOrganizer,
      isCancelled: isCancelled ?? this.isCancelled,
    );
  }
}

const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

String formatEventDay(DateTime day) {
  final weekday = _weekdays[day.weekday - 1];
  final month = _months[day.month - 1];
  return '$weekday ${day.day} $month ${day.year}';
}

String eventMonthLabel(DateTime day) {
  return _months[day.month - 1].toUpperCase();
}

// "16 Nov · 10:30"
String formatShortDayTime(DateTime time) {
  final hour = time.hour.toString().padLeft(2, '0');
  final minute = time.minute.toString().padLeft(2, '0');
  return '${time.day} ${_months[time.month - 1]} · $hour:$minute';
}
