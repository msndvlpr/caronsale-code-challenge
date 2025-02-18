import 'dart:convert';

import 'package:auction_repository/auction_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:caronsale_code_challenge/user_authentication/bloc/user_auth_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_auction/bloc/auction_data_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_search/cubit/settings_cubit.dart';
import 'package:caronsale_code_challenge/vehicle_search/cubit/theme_cubit.dart';
import 'package:caronsale_code_challenge/vehicle_search/view/vehicle_search_screen.dart';
import 'package:caronsale_code_challenge/vehicle_search/widget/custom_list_tile_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_api/network_api_service.dart';
import 'package:secure_storage_api/secure_storage_api.dart';


class MockAuctionDataBloc extends Mock implements AuctionDataBloc {}
class MockSecureStorageApi extends Mock implements SecureStorageApi {}
class MockNetworkApiService extends Mock implements NetworkApiService {}
class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockAuctionRepository extends Mock implements AuctionRepository {}
class FakeScreenRoute extends Fake implements Route<dynamic> {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}


void main() {

  const jsonBody200Response = '''
 {
      "id": 52972,
      "feedback": "Please modify the price.",
      "valuatedAt": "2023-01-05T14:08:40.456Z",
      "requestedAt": "2023-01-05T14:08:40.456Z",
      "createdAt": "2023-01-05T14:08:40.456Z",
      "updatedAt": "2023-01-05T14:08:42.153Z",
      "make": "Toyota",
      "model": "GT 86 Basis",
      "externalId": "DE003-018601450020008",
      "_fk_sellerUser": "25475e37-6973-483b-9b15-cfee721fc29f",
      "price": 327,
      "positiveCustomerFeedback": false,
      "_fk_uuid_auction": "3e255ad2-36d4-4048-a962-5e84e27bfa6e",
      "inspectorRequestedAt": "2023-01-05T14:08:40.456Z",
      "origin": "AUCTION",
      "estimationRequestId": "3a295387d07f"
    }''';

  late MockAuctionDataBloc mockAuctionDataBloc;

  late AuctionRepository auctionRepository;
  late AuthenticationRepository authenticationRepository;
  late SecureStorageApi secureStorageApi;

  late AuctionData auctionData;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    auctionRepository = MockAuctionRepository();
    authenticationRepository = MockAuthenticationRepository();
    secureStorageApi = MockSecureStorageApi();
    mockAuctionDataBloc = MockAuctionDataBloc();
    auctionData = AuctionData.fromJson(jsonDecode(jsonBody200Response));
    mockNavigatorObserver = MockNavigatorObserver();
  });

  setUpAll((){
    registerFallbackValue(FakeScreenRoute());
  });

  Widget makeTestableWidget(Widget child) {
    return MaterialApp(
        home: MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuctionRepository>.value(value: auctionRepository),
        RepositoryProvider<AuthenticationRepository>.value(value: authenticationRepository),
        RepositoryProvider<SecureStorageApi>.value(value: secureStorageApi),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UserAuthBloc(context.read<AuthenticationRepository>())),
          BlocProvider(create: (context) => AuctionDataBloc(context.read<AuctionRepository>())),
          BlocProvider(create: (_) => ThemeCubit()),
          BlocProvider(create: (_) => SettingsCubit()),
        ],
        child: child,
      ),
    ));
  }

  group('VehicleSearchScreen', () {
    testWidgets(
      'GIVEN VehicleSearchScreen WHEN rendered THEN should display input field, button, and switch',
      (WidgetTester tester) async {
        await tester.pumpWidget(makeTestableWidget(VehicleSearchScreen()));

        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Find auctions for VIN'), findsOneWidget);
        expect(find.byType(CacheToggleSwitch), findsOneWidget);
      },
    );

    testWidgets(
      'GIVEN empty VIN input WHEN submitted THEN should show validation error',
      (WidgetTester tester) async {
        await tester.pumpWidget(makeTestableWidget(VehicleSearchScreen()));

        await tester.tap(find.text('Find auctions for VIN'));
        await tester.pump();

        expect(find.text('VIN number must be 17 characters'), findsOneWidget);
      },
    );

    testWidgets(
      'GIVEN low length VIN input WHEN submitted THEN should show validation error',
      (WidgetTester tester) async {
        await tester.pumpWidget(makeTestableWidget(VehicleSearchScreen()));

        await tester.enterText(find.byType(TextFormField), 'LOW_LENGTH_VIN');
        await tester.tap(find.text('Find auctions for VIN'));
        await tester.pump();

        expect(find.textContaining('VIN number must be 17 characters'),
            findsOneWidget);
      },
    );

    testWidgets(
      'GIVEN invalid VIN input WHEN submitted THEN should show validation error',
      (WidgetTester tester) async {
        await tester.pumpWidget(makeTestableWidget(VehicleSearchScreen()));

        await tester.enterText(find.byType(TextFormField), 'OTHER_INVALID_VIN');
        await tester.tap(find.text('Find auctions for VIN'));
        await tester.pump();

        expect(find.textContaining('Illegal character'), findsOneWidget);
      },
    );

    testWidgets(
      'GIVEN valid VIN input WHEN submitted THEN should trigger AuctionDataFetched event',
      (WidgetTester tester) async {
        when(() => mockAuctionDataBloc.state)
            .thenReturn(AuctionDataStateSuccess(auctionData: auctionData));

        when(() => auctionRepository.fetchAuctionDataByVin(any()))
            .thenAnswer((_) => Future.value(auctionData));

        await tester.pumpWidget(makeTestableWidget(VehicleSearchScreen()));
        expect(find.byType(CircularProgressIndicator), findsNothing);
      },
    );

    testWidgets(
        'GIVEN bloc success event is raised THEN the data state is also success THEN should not display CircularProgressIndicator when data is loaded',
        (WidgetTester tester) async {
      when(() => mockAuctionDataBloc.state)
          .thenReturn(AuctionDataStateSuccess(auctionData: auctionData));
      when(() => mockAuctionDataBloc.stream).thenAnswer((_) =>
          Stream.fromIterable(
              [AuctionDataStateSuccess(auctionData: auctionData)]));

      when(() => auctionRepository.fetchAuctionDataByVin('vin'))
          .thenAnswer((_) async => auctionData);

      await tester.pumpWidget(makeTestableWidget(VehicleSearchScreen()));
      await tester.pumpAndSettle();

      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        'GIVEN VehicleSearchScreen with the passed vehicle items WHEN view is rendered and an listTile is tapped THEN should navigate to next screen',
            (WidgetTester tester) async {

      when(() => auctionRepository.fetchAuctionDataByVin(any()))
          .thenAnswer((_) => Future.value(auctionData));

      await tester.pumpWidget(
          makeTestableWidget(MaterialApp(
            navigatorObservers: [mockNavigatorObserver],
            home: VehicleSearchScreen()
          ))
      );

      expect(find.byType(ElevatedButton), findsNWidgets(1));

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);

    });

  });
}
