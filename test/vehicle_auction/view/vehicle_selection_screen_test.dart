import 'package:auction_repository/auction_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:caronsale_code_challenge/user_authentication/bloc/user_auth_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_auction/bloc/auction_data_bloc.dart';
import 'package:caronsale_code_challenge/vehicle_auction/model/vehicle_options_entity.dart';
import 'package:caronsale_code_challenge/vehicle_auction/view/auction_details_screen.dart';
import 'package:caronsale_code_challenge/vehicle_auction/view/vehicle_selection_screen.dart';
import 'package:caronsale_code_challenge/vehicle_search/cubit/settings_cubit.dart';
import 'package:caronsale_code_challenge/vehicle_search/cubit/theme_cubit.dart';
import 'package:caronsale_code_challenge/vehicle_search/view/vehicle_search_screen.dart';
import 'package:caronsale_code_challenge/vehicle_search/widget/custom_list_tile_switch.dart';
import 'package:caronsale_code_challenge/vehicle_search/widget/custom_switch.dart';
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
class FakeAuctionDataEvent extends Fake implements AuctionDataFetched {}
class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class FakeScreenRoute extends Fake implements Route<dynamic> {}


void main() {

  const jsonBody300Response = '''[
     {
        "make": "Toyota",
        "model": "GT 86 Basis",
        "containerName": "DE - Cp2 2.0 EU5, 2012 - 2015",
        "similarity": 53,
        "externalId": "DE001-018601450020001"
    },
    {
        "make": "Toyota",
        "model": "GT 86 Basis",
        "containerName": "DE - Cp2 2.0 EU6, (EURO 6), 2015 - 2017",
        "similarity": 50,
        "externalId": "DE002-018601450020001"
    },
    {
        "make": "Toyota",
        "model": "GT 86 Basis",
        "containerName": "DE - Cp2 2.0 EU6, Basis, 2017 - 2020",
        "similarity": 0,
        "externalId": "DE003-018601450020001"
    }
]''';

  late MockAuctionDataBloc mockAuctionDataBloc;

  late AuctionRepository auctionRepository;
  late AuthenticationRepository authenticationRepository;
  late SecureStorageApi secureStorageApi;

  late VehicleOptionItems vehicleOptionItems;
  late MockNavigatorObserver mockNavigatorObserver;

  setUp(() {
    auctionRepository = MockAuctionRepository();
    authenticationRepository = MockAuthenticationRepository();
    secureStorageApi = MockSecureStorageApi();
    mockAuctionDataBloc = MockAuctionDataBloc();
    vehicleOptionItems = VehicleOptionItems.fromJson(jsonBody300Response);
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
            child: child
          ),
        ));
  }

  group('VehicleSelectionScreen', () {

    testWidgets(
      'GIVEN VehicleSelectionScreen with the passed vehicle items WHEN view is rendered THEN should display text, listTile, and cards',
          (WidgetTester tester) async {
        await tester.pumpWidget(makeTestableWidget(VehicleSelectionScreen(vehicleOptionsEntity: VehicleOptionsEntity.fromVehicleOptions(vehicleOptionItems))));

        expect(find.byType(Text), findsAny);
        expect(find.byType(CustomSwitch), findsOneWidget);
        expect(find.byType(ListView), findsOneWidget);
        expect(find.byType(Card), findsExactly(3));
        expect(find.byType(ListTile), findsExactly(3));
        expect(find.byType(CircularProgressIndicator), findsExactly(3));//As the similarity indicator
      },
    );

    testWidgets('GIVEN VehicleSelectionScreen with the passed vehicle items WHEN view is rendered and an listTile is tapped THEN should navigate to next screen', (WidgetTester tester) async {

      when(() => auctionRepository.fetchVehicleDataByExternalId(any()))
          .thenAnswer((_) => Future.value(vehicleOptionItems));

      await tester.pumpWidget(
        makeTestableWidget(MaterialApp(
          navigatorObservers: [mockNavigatorObserver],
          home: VehicleSelectionScreen(vehicleOptionsEntity: VehicleOptionsEntity.fromVehicleOptions(vehicleOptionItems)),
        ))
      );

      expect(find.byType(ListTile), findsNWidgets(vehicleOptionItems.items.length));

      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      verify(() => mockNavigatorObserver.didPush(any(), any())).called(1);

    });

  });
}
