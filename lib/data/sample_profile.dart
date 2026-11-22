import '../models/user_profile.dart';

// Options shown on the Edit Profile form.
const List<String> profileFaculties = [
  'Engineering',
  'Science',
  'Arts',
  'Business',
];

const List<int> profileYears = [1, 2, 3, 4];

const List<String> profileInterests = [
  'Photography',
  'Board games',
  'Technology',
  'Sports',
  'Music',
  'Volunteering',
  'Arts',
];

// Placeholder signed-in user. Real data comes in with Firebase later.
const UserProfile sampleProfile = UserProfile(
  name: 'Alp Gül',
  email: 'alp.gul@sabanciuniv.edu',
  faculty: 'Engineering',
  year: 2,
  bio:
      'Engineering student into robotics, film nights and early morning '
      'runs around campus.',
  interests: ['Technology', 'Sports', 'Board games'],
);
