import 'package:campusconnect/data/my_events.dart';
import 'package:campusconnect/screens/my_events_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('leaving an event removes its card and undo brings it back', (
    tester,
  ) async {
    final original = List.of(myEvents);
    addTearDown(() {
      myEvents
        ..clear()
        ..addAll(original);
    });

    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MyEventsScreen())),
    );

    expect(find.text('3 events you joined'), findsOneWidget);
    expect(find.text('Campus Film Night'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pumpAndSettle();
    expect(find.text('Leave this event?'), findsOneWidget);

    await tester.tap(find.text('Leave'));
    await tester.pumpAndSettle();
    expect(find.text('Campus Film Night'), findsNothing);
    expect(find.text('2 events you joined'), findsOneWidget);
    expect(find.text('Left Campus Film Night'), findsOneWidget);

    await tester.tap(find.text('Undo'));
    await tester.pumpAndSettle();
    expect(find.text('Campus Film Night'), findsOneWidget);
    expect(find.text('3 events you joined'), findsOneWidget);
  });

  testWidgets('cancel keeps the event in the list', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: MyEventsScreen())),
    );

    await tester.tap(find.byIcon(Icons.close).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(find.text('Campus Film Night'), findsOneWidget);
    expect(find.text('3 events you joined'), findsOneWidget);
  });
}
