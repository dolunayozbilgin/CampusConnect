import 'package:campusconnect/screens/login_screen.dart';
import 'package:campusconnect/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() {
  return const MaterialApp(home: Scaffold(body: ProfileScreen()));
}

void main() {
  testWidgets('profile shows the placeholder user', (tester) async {
    await tester.pumpWidget(_app());

    expect(find.text('Alp Gül'), findsOneWidget);
    expect(find.text('Engineering · Year 2'), findsOneWidget);
    expect(find.text('Interests'), findsWidgets);
  });

  testWidgets('profile fits a small phone without overflow', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_app());

    expect(tester.takeException(), isNull);
  });

  testWidgets('edit profile shows an error for an empty name', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.tap(find.text('Save changes'));
    await tester.pump();

    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Profile updated'), findsNothing);
  });

  testWidgets('saving a valid edit updates the profile', (tester) async {
    await tester.pumpWidget(_app());
    await tester.tap(find.text('Edit'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Deniz Yılmaz');
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    expect(find.text('Profile updated'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Deniz Yılmaz'), findsOneWidget);
  });

  testWidgets('log out asks first and then opens Login', (tester) async {
    await tester.pumpWidget(_app());

    final logOut = find.text('Log out');
    await tester.ensureVisible(logOut);
    await tester.tap(logOut);
    await tester.pumpAndSettle();
    expect(find.text('Log out?'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Log out'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
