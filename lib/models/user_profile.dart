class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.faculty,
    required this.year,
    required this.bio,
    required this.interests,
  });

  final String name;
  final String email;
  final String faculty;
  final int year;
  final String bio;
  final List<String> interests;

  String get subtitle => '$faculty · Year $year';

  // Returns a new profile with only the given fields changed. The email
  // never changes because it comes from the university account.
  UserProfile copyWith({
    String? name,
    String? faculty,
    int? year,
    String? bio,
    List<String>? interests,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email,
      faculty: faculty ?? this.faculty,
      year: year ?? this.year,
      bio: bio ?? this.bio,
      interests: interests ?? this.interests,
    );
  }
}
