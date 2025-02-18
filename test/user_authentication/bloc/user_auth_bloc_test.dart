import 'dart:convert';

import 'package:auction_repository/auction_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:caronsale_code_challenge/user_authentication/bloc/user_auth_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_auction/bloc/auction_data_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_api/network_api_service.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

void main() {

  late MockAuthenticationRepository mockRepository;
  late UserAuthBloc userAuthBloc;

  setUpAll(() {
    registerFallbackValue('vin');
  });

  setUp(() {
    mockRepository = MockAuthenticationRepository();
    userAuthBloc = UserAuthBloc(mockRepository);
  });

  tearDown(() {
    userAuthBloc.close();
  });

  final mockData = 'some-jwt-token';

  group('UserAuthBloc', () {

    blocTest<UserAuthBloc, UserAuthState>(
      'GIVEN AuthenticationRepository returns data for user authentication WHEN UserAuthDataFetched event is added THEN emit [Loading, Success] with the fetched token',
      build: () {
        when(() => mockRepository.authenticateUserByCredentials('username', 'password'))
            .thenAnswer((_) async => mockData);
        return userAuthBloc;
      },
      act: (bloc) => bloc.add(UserAuthDataFetched(username: 'username', password: 'password')),
      expect: () => [
        UserAuthDataStateLoading(),
        UserAuthDataStateSuccess(token: mockData),
      ],
    );

    blocTest<UserAuthBloc, UserAuthState>(
      'GIVEN AuthenticationRepository returns data for user authentication WHEN UserAuthDataFetched event is added THEN emit [Loading, Exception] with the exception thrown',
      build: () {
        when(() => mockRepository.authenticateUserByCredentials('username', 'password')).
        thenThrow(Exception('Incorrect username or password.'));
        return userAuthBloc;
      },
      act: (bloc) => bloc.add(UserAuthDataFetched(username: 'username', password: 'password')),
      expect: () => [
        UserAuthDataStateLoading(),
        UserAuthDataStateFailure(errorMessage: 'Exception: Incorrect username or password.')
      ],
    );


  });
}
