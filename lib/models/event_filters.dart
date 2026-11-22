import 'campus_event.dart';

enum DateRange { any, today, thisWeek, custom }

// What the user picked on the Filters screen. An empty category set means
// "All", and a null location means "All campus locations".
class EventFilters {
  const EventFilters({
    this.range = DateRange.any,
    this.from,
    this.to,
    this.categories = const {},
    this.location,
  });

  final DateRange range;
  final DateTime? from;
  final DateTime? to;
  final Set<String> categories;
  final String? location;

  bool get isActive =>
      range != DateRange.any || categories.isNotEmpty || location != null;

  bool matches(CampusEvent event, {DateTime? now}) {
    if (categories.isNotEmpty && !categories.contains(event.category)) {
      return false;
    }
    if (location != null && !event.location.startsWith(location!)) {
      return false;
    }
    return _dateMatches(_dayOnly(event.day), _dayOnly(now ?? DateTime.now()));
  }

  bool _dateMatches(DateTime day, DateTime today) {
    switch (range) {
      case DateRange.any:
        return true;
      case DateRange.today:
        return day == today;
      case DateRange.thisWeek:
        // Monday to Sunday of the current week.
        final monday = today.subtract(Duration(days: today.weekday - 1));
        final sunday = monday.add(const Duration(days: 6));
        return !day.isBefore(monday) && !day.isAfter(sunday);
      case DateRange.custom:
        if (from != null && day.isBefore(_dayOnly(from!))) return false;
        if (to != null && day.isAfter(_dayOnly(to!))) return false;
        return true;
    }
  }

  static DateTime _dayOnly(DateTime time) =>
      DateTime(time.year, time.month, time.day);
}
