class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.faculty,
    required this.year,
    required this.bio,
    required this.interests,
    required this.joinedCount,
    required this.organizedCount,
  });

  final String name;
  final String email;
  final String faculty;
  final int year;
  final String bio;
  final List<String> interests;
  final int joinedCount;
  final int organizedCount;

  String get subtitle => '$faculty · Year $year';

  // Returns a new profile with only the given fields changed.
  UserProfile copyWith({String? name, String? faculty, String? bio}) {
    return UserProfile(
      name: name ?? this.name,
      email: email,
      faculty: faculty ?? this.faculty,
      year: year,
      bio: bio ?? this.bio,
      interests: interests,
      joinedCount: joinedCount,
      organizedCount: organizedCount,
    );
  }
}
