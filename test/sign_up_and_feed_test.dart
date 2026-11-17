import 'dart:async';
import 'dart:io';

import 'package:campusconnect/screens/event_feed_screen.dart';
import 'package:campusconnect/screens/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _tapCreateAccount(WidgetTester tester) async {
  final button = find.text('Create account');
  await tester.ensureVisible(button);
  await tester.pump();
  await tester.tap(button);
  await tester.pump();
}

void main() {
  setUpAll(() {
    HttpOverrides.global = _TestHttpOverrides();
  });

  testWidgets('empty sign up shows an error under each field', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

    await _tapCreateAccount(tester);

    expect(find.text('Please enter your university email'), findsOneWidget);
    expect(find.text('Please enter your password'), findsOneWidget);
    expect(find.text('Please re-enter your password'), findsOneWidget);
  });

  testWidgets('sign up rejects a short password and a mismatched confirm', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Deniz Yilmaz');
    await tester.enterText(fields.at(1), 'deniz@university.edu');
    await tester.enterText(fields.at(2), 'short');
    await tester.enterText(fields.at(3), 'different');
    await _tapCreateAccount(tester);

    expect(find.text('Use at least 8 characters'), findsOneWidget);
    expect(find.text('Passwords do not match'), findsOneWidget);
    expect(find.text('Account created'), findsNothing);
  });

  testWidgets('a valid sign up opens the confirmation dialog', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Deniz Yilmaz');
    await tester.enterText(fields.at(1), 'deniz@university.edu');
    await tester.enterText(fields.at(2), 'campus123');
    await tester.enterText(fields.at(3), 'campus123');
    await _tapCreateAccount(tester);

    expect(find.text('Account created'), findsOneWidget);
    expect(find.textContaining('Welcome, Deniz Yilmaz'), findsOneWidget);
  });

  testWidgets('event feed lists cards and can filter them away', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: EventFeedScreen()));
    await tester.pump();

    expect(find.text('Campus Film Night'), findsOneWidget);
    expect(find.byType(Card), findsWidgets);

    await tester.enterText(find.byType(TextField), 'no such event');
    await tester.pump();

    expect(find.text('No events found'), findsOneWidget);
    expect(find.text('Campus Film Night'), findsNothing);
  });
}

class _TestHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return _QuietHttpClient();
  }
}

// Cover photos are network images. Tests should not call Unsplash.
class _QuietHttpClient implements HttpClient {
  @override
  Future<HttpClientRequest> getUrl(Uri url) async => _QuietRequest();

  @override
  Future<HttpClientRequest> openUrl(String method, Uri url) async =>
      _QuietRequest();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _QuietRequest implements HttpClientRequest {
  @override
  HttpHeaders get headers => _QuietHeaders();

  @override
  Future<HttpClientResponse> close() async => _QuietResponse();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _QuietHeaders implements HttpHeaders {
  @override
  void add(String name, Object value, {bool preserveHeaderCase = false}) {}

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _QuietResponse implements HttpClientResponse {
  static const _png = <int>[
    0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, 0x00, 0x00, 0x00, 0x0D,
    0x49, 0x48, 0x44, 0x52, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
    0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, 0x89, 0x00, 0x00, 0x00,
    0x0A, 0x49, 0x44, 0x41, 0x54, 0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00,
    0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49,
    0x45, 0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
  ];

  @override
  int get statusCode => 200;

  @override
  int get contentLength => _png.length;

  @override
  HttpClientResponseCompressionState get compressionState =>
      HttpClientResponseCompressionState.notCompressed;

  @override
  StreamSubscription<List<int>> listen(
    void Function(List<int> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return Stream<List<int>>.fromIterable(<List<int>>[_png]).listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
