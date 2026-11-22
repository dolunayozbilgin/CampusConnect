import 'package:campusconnect/data/sample_profile.dart';
import 'package:campusconnect/screens/login_screen.dart';
import 'package:campusconnect/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _signUp(WidgetTester tester) async {
  await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), 'Deniz Yilmaz');
  await tester.enterText(fields.at(1), 'deniz@university.edu');
  await tester.enterText(fields.at(2), 'campus123');
  await tester.enterText(fields.at(3), 'campus123');

  final create = find.text('Create account');
  await tester.ensureVisible(create);
  await tester.tap(create);
  await tester.pumpAndSettle();
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('forgot password opens Reset password and validates', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    final forgot = find.text('Forgot password?');
    await tester.ensureVisible(forgot);
    await tester.tap(forgot);
    await tester.pumpAndSettle();
    expect(find.text('Send reset link'), findsOneWidget);

    await tester.tap(find.text('Send reset link'));
    await tester.pump();
    expect(find.text('Please enter your university email'), findsOneWidget);
  });

  testWidgets('a valid reset shows a neutral message and returns to Login', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    final forgot = find.text('Forgot password?');
    await tester.ensureVisible(forgot);
    await tester.tap(forgot);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), 'deniz@university.edu');
    await tester.tap(find.text('Send reset link'));
    await tester.pumpAndSettle();
    expect(
      find.text("If an account exists for this email, we'll send a reset link."),
      findsOneWidget,
    );

    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Back to login'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Send reset link'), findsNothing);
  });

  testWidgets('sign up opens Complete your profile with the new account', (
    tester,
  ) async {
    await _signUp(tester);

    expect(find.text('Complete your profile'), findsOneWidget);
    expect(find.text('deniz@university.edu'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Event Feed'), findsOneWidget);
  });

  testWidgets('saving Complete your profile needs an interest', (
    tester,
  ) async {
    addTearDown(() => currentProfile = sampleProfile);
    await _signUp(tester);

    await tester.tap(find.text('Save profile'));
    await tester.pump();
    expect(find.text('Select at least one interest'), findsOneWidget);

    await tester.ensureVisible(find.text('Sports'));
    await tester.tap(find.text('Sports'));
    await tester.tap(find.text('Save profile'));
    await tester.pumpAndSettle();

    expect(find.text('Event Feed'), findsOneWidget);
    expect(currentProfile.name, 'Deniz Yilmaz');
    expect(currentProfile.interests, ['Sports']);
  });
}
