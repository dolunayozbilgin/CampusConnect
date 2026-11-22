import '../models/event_comment.dart';
import '../models/student.dart';

// Placeholder students shown as attendees. Real data comes with Firebase.
const List<Student> sampleStudents = [
  Student(name: 'Emre Aksoy', faculty: 'Science', year: 1),
  Student(name: 'Karya Sert', faculty: 'Business', year: 2),
  Student(name: 'Senih Kırmaç', faculty: 'Arts', year: 3),
  Student(name: 'Dolunay Özbilgin', faculty: 'Science', year: 4),
  Student(name: 'Alp Gül', faculty: 'Engineering', year: 2),
  Student(name: 'Deniz Yılmaz', faculty: 'Engineering', year: 2),
  Student(name: 'Ece Tan', faculty: 'Arts', year: 1),
  Student(name: 'Mert Kaya', faculty: 'Engineering', year: 3),
  Student(name: 'Zeynep Arslan', faculty: 'Business', year: 4),
  Student(name: 'Can Öztürk', faculty: 'Science', year: 2),
  Student(name: 'Selin Demir', faculty: 'Engineering', year: 1),
  Student(name: 'Burak Şahin', faculty: 'Arts', year: 2),
];

// Comments per event id. Lists are mutable so new comments stay for the
// rest of the session.
final Map<String, List<EventComment>> sampleComments = {
  'photo-walk': [
    EventComment(
      author: 'Dolunay Özbilgin',
      text: 'Meet at North Gate at 16:00. Bring a camera or your phone!',
      time: DateTime(2026, 11, 16, 10, 30),
    ),
    EventComment(
      author: 'Emre Aksoy',
      text: 'Is this suitable for beginners?',
      time: DateTime(2026, 11, 16, 11, 5),
    ),
    EventComment(
      author: 'Karya Sert',
      text: 'Yes! I am joining with just my phone.',
      time: DateTime(2026, 11, 16, 11, 12),
    ),
  ],
  'film-night': [
    EventComment(
      author: 'Senih Kırmaç',
      text: 'Which film are we watching?',
      time: DateTime(2026, 11, 15, 18, 40),
    ),
  ],
};

List<EventComment> commentsFor(String eventId) {
  return sampleComments.putIfAbsent(eventId, () => []);
}
