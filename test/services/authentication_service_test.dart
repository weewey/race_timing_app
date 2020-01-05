import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'package:race_timing_app/models/user.dart';
import 'package:race_timing_app/services/authentication_service.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  MockClient mockClient;
  AuthenticationService authService;

  setUp(() {
    mockClient = MockClient();
    authService = AuthenticationService();
    authService.client = mockClient;
  });

  test('throws an error with the error message when user login is incorrect',
      () async {
    when(mockClient.post(argThat(contains("/api/login")),
            body: anyNamed('body'), headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(
              jsonEncode({
                'error': 'You need to sign in or sign up before continuing'
              }),
              401,
            ));

    await authService.authenticate(email: "", password: "").catchError(
        (error) => expect(
            error.message, equals("Please check the login details provided.")));
  });

  group('when it is a valid user', () {
    User user;
    User result;

    setUp(() async {
      user = User(id: 1, email: "user@example.com", token: "token");
      when(mockClient.post(argThat(contains("/api/login")),
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(
              jsonEncode({"id": user.id, "email": user.email}), 200,
              headers: {"authorization": user.token}));
      result = await authService.authenticate(email: user.email, password: "password");
    });

    test('authenticate returns a user when it is successful', () {
      expect(result.email, equals(user.email));
      expect(result.token, equals(user.token));
      expect(result.id, equals(user.id));
    });

    test('adds user to onAuthStateChanged', () {
      authService.onAuthStateChanged.listen((result){
        expect(result.email, user.email);
        expect(result.token, user.token);
        expect(result.id, user.id);
      });
    });

  });
}
