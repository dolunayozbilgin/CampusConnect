import '../models/campus_event.dart';

// Placeholder events for the feed. Real data comes in with Firebase later.
final List<CampusEvent> sampleEvents = [
  CampusEvent(
    title: 'Campus Film Night',
    category: 'Arts',
    day: DateTime(2026, 11, 18),
    timeRange: '19:00–21:00',
    location: 'Student Union, Room 204',
    going: 20,
    capacity: 20,
    imageUrl:
        'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?auto=format&fit=crop&w=800&q=60',
    initials: ['DÖ', 'EA', 'DY'],
  ),
  CampusEvent(
    title: 'Photography Walk',
    category: 'Arts',
    day: DateTime(2026, 11, 18),
    timeRange: '16:00–18:00',
    location: 'North Gate',
    going: 12,
    capacity: 20,
    imageUrl:
        'https://images.unsplash.com/photo-1452587925148-ce544e77e70d?auto=format&fit=crop&w=800&q=60',
    initials: ['DY', 'EA', 'KS'],
  ),
  CampusEvent(
    title: 'Campus 5K',
    category: 'Sports',
    day: DateTime(2026, 11, 21),
    timeRange: '08:00–09:30',
    location: 'North Gate',
    going: 14,
    capacity: 40,
    imageUrl:
        'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?auto=format&fit=crop&w=800&q=60',
    initials: ['AG', 'SK'],
  ),
  CampusEvent(
    title: 'Midterm Study Group',
    category: 'Academic',
    day: DateTime(2026, 11, 19),
    timeRange: '18:00–20:00',
    location: 'Student Union, Room 204',
    going: 9,
    capacity: 16,
    imageUrl:
        'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=800&q=60',
    initials: ['EA', 'DÖ'],
  ),
  CampusEvent(
    title: 'Shelter Visit',
    category: 'Volunteering',
    day: DateTime(2026, 11, 22),
    timeRange: '11:00–14:00',
    location: 'North Gate',
    going: 7,
    capacity: 15,
    imageUrl:
        'https://images.unsplash.com/photo-1559027615-cd4628902d4a?auto=format&fit=crop&w=800&q=60',
    initials: ['KS', 'AG', 'SK'],
  ),
];
