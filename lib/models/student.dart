class Student {
  const Student({
    required this.name,
    required this.faculty,
    required this.year,
  });

  final String name;
  final String faculty;
  final int year;

  String get subtitle => '$faculty · Year $year';
}
