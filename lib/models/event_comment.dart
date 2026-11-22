class EventComment {
  const EventComment({
    required this.author,
    required this.text,
    required this.time,
    this.isMine = false,
  });

  final String author;
  final String text;
  final DateTime time;
  // Only your own comments can be deleted.
  final bool isMine;
}
