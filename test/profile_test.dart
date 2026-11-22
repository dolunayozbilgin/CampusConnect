import 'package:campusconnect/screens/login_screen.dart';
import 'package:campusconnect/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _app() {
  return const MaterialApp(home: Scaffold(body: ProfileScreen()));
}

Future<void> _openEdit(WidgetTester tester) async {
  await tester.pumpWidget(_app());
  await tester.tap(find.text('Edit profile'));
  await tester.pumpAndSettle();
}

void _useSmallPhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(320, 568);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('profile shows the placeholder user', (tester) async {
    await tester.pumpWidget(_app());

    expect(find.text('Alp Gül'), findsOneWidget);
    expect(find.text('Engineering · Year 2'), findsOneWidget);
    expect(find.text('About me'), findsOneWidget);
    expect(find.text('Technology'), findsOneWidget);
  });

  testWidgets('profile fits a small phone without overflow', (tester) async {
    _useSmallPhone(tester);
    await tester.pumpWidget(_app());

    expect(tester.takeException(), isNull);
  });

  testWidgets('edit profile fits a small phone without overflow', (
    tester,
  ) async {
    _useSmallPhone(tester);
    await _openEdit(tester);

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('edit profile shows an error for an empty name', (tester) async {
    await _openEdit(tester);

    await tester.enterText(find.byType(TextFormField).first, '');
    await tester.tap(find.text('Save profile'));
    await tester.pump();

    expect(find.text('Enter your full name'), findsOneWidget);
    expect(find.text('Profile updated'), findsNothing);
  });

  testWidgets('edit profile needs at least one interest', (tester) async {
    await _openEdit(tester);

    for (final interest in ['Technology', 'Sports', 'Board games']) {
      await tester.ensureVisible(find.text(interest));
      await tester.tap(find.text(interest));
      await tester.pump();
    }
    expect(find.text('0 selected'), findsOneWidget);

    await tester.tap(find.text('Save profile'));
    await tester.pump();

    expect(find.text('Select at least one interest'), findsOneWidget);
    expect(find.text('Profile updated'), findsNothing);
  });

  testWidgets('saving a valid edit updates the profile', (tester) async {
    await _openEdit(tester);

    await tester.enterText(find.byType(TextFormField).first, 'Deniz Yılmaz');
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();
    expect(find.text('Profile updated'), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('Deniz Yılmaz'), findsOneWidget);
  });

  testWidgets('cancel with changes asks before discarding', (tester) async {
    await _openEdit(tester);

    await tester.enterText(find.byType(TextFormField).first, 'Someone Else');
    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Discard changes?'), findsOneWidget);

    await tester.tap(find.text('Discard'));
    await tester.pumpAndSettle();
    expect(find.text('Alp Gül'), findsOneWidget);
    expect(find.text('Someone Else'), findsNothing);
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
