import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart';
import 'package:http/testing.dart';

class MockHttpAuthHandler {
  MockHttpAuthHandler._();

  static const String authHeader = 'Authorization';
  static const String mockUsername = 'user';
  static const String validToken = 'mocked_jwt_token';

  static final BaseClient httpClient = MockClient((request) async {
    if (request.url.path == '/login' && request.method == 'POST') {
      return _handleLogin(request);
    }
    await Future<void>.delayed(const Duration(seconds: 1));

    return Response(jsonEncode({'error': 'Requested Service Is Not found'}), 404);
  });

  static Future<Response> _handleLogin(Request request) async {

    final Map<String, dynamic> body = jsonDecode(await request.body);
    final String? auth = body['auth'];

    if (auth == mockUsername) {
      return Response(jsonEncode({'token': validToken}), 200);
    }
    return Response(jsonEncode({'error': 'Invalid credentials'}), 401);
  }
}
