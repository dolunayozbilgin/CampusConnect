import 'package:campusconnect/data/sample_events.dart';
import 'package:campusconnect/models/event_filters.dart';
import 'package:campusconnect/screens/event_feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _openFilters(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: EventFeedScreen()));
  await tester.tap(find.byTooltip('Filters'));
  await tester.pumpAndSettle();
}

void main() {
  final filmNight = sampleEvents.firstWhere(
    (e) => e.title == 'Campus Film Night',
  );
  final fiveK = sampleEvents.firstWhere((e) => e.title == 'Campus 5K');

  test('custom range keeps only events between the two dates', () {
    final filters = EventFilters(
      range: DateRange.custom,
      from: DateTime(2026, 11, 19),
      to: DateTime(2026, 11, 21),
    );

    expect(filters.matches(fiveK), isTrue);
    expect(filters.matches(filmNight), isFalse);
  });

  test('this week runs from Monday to Sunday', () {
    const filters = EventFilters(range: DateRange.thisWeek);
    final wednesday = DateTime(2026, 11, 18);

    expect(filters.matches(filmNight, now: wednesday), isTrue);
    expect(filters.matches(filmNight, now: DateTime(2026, 11, 25)), isFalse);
  });

  test('location matches events in that place', () {
    const filters = EventFilters(location: 'Student Union');

    expect(filters.matches(filmNight), isTrue);
    expect(filters.matches(fiveK), isFalse);
  });

  testWidgets('filter icon opens Filters and applies a category', (
    tester,
  ) async {
    await _openFilters(tester);
    expect(find.text('Find something that fits your schedule.'), findsOneWidget);

    await tester.tap(find.text('Sports'));
    await tester.tap(find.text('Apply filters'));
    await tester.pumpAndSettle();

    expect(find.text('Campus 5K'), findsOneWidget);
    expect(find.text('Campus Film Night'), findsNothing);
  });

  testWidgets('custom range shows date errors when left empty', (
    tester,
  ) async {
    await _openFilters(tester);
    expect(find.text('From'), findsNothing);

    await tester.tap(find.text('Custom'));
    await tester.pump();
    expect(find.text('From'), findsOneWidget);

    await tester.tap(find.text('Apply filters'));
    await tester.pump();

    expect(find.text('Pick a start date'), findsOneWidget);
    expect(find.text('Pick an end date'), findsOneWidget);
  });

  testWidgets('reset clears choices before applying', (tester) async {
    await _openFilters(tester);

    await tester.tap(find.text('Sports'));
    await tester.tap(find.text('Reset filters'));
    await tester.tap(find.text('Apply filters'));
    await tester.pumpAndSettle();

    expect(find.text('Campus Film Night'), findsOneWidget);
  });
}
