import '../models/campus_event.dart';
import 'sample_events.dart';

// Placeholder: events the current user (EA) has joined.
final List<CampusEvent> myEvents = sampleEvents
    .where((event) => event.initials.contains('EA'))
    .toList();
