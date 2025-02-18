import 'dart:convert';

import 'package:auction_repository/auction_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:caronsale_code_challenge/vehicle_auction/bloc/auction_data_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_api/network_api_service.dart';

class MockAuctionRepository extends Mock implements AuctionRepository {}

void main() {

  late MockAuctionRepository mockRepository;
  late AuctionDataBloc auctionDataBloc;

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

  setUpAll(() {
    registerFallbackValue('vin');
  });

  setUp(() {
    mockRepository = MockAuctionRepository();
    auctionDataBloc = AuctionDataBloc(mockRepository);
  });

  tearDown(() {
    auctionDataBloc.close();
  });

  final mockData = AuctionData.fromJson(jsonDecode(jsonBody200Response));

  group('AuctionDataBloc', () {

    blocTest<AuctionDataBloc, AuctionDataState>(
      'GIVEN AuctionRepository returns data for auctions WHEN AuctionDataFetched event is added THEN emit [Loading, Success] with the fetched data',
      build: () {
        when(() => mockRepository.fetchAuctionDataByVin(any()))
            .thenAnswer((_) async => mockData);
        when(() => mockRepository.fetchVehicleDataByExternalId(any()))
            .thenAnswer((_) async => mockData);
        return auctionDataBloc;
      },
      act: (bloc) => bloc.add(AuctionDataFetched(vin: 'vin')),
      expect: () => [
        AuctionDataStateLoading(),
        AuctionDataStateSuccess(auctionData: mockData),
      ],
    );

    blocTest<AuctionDataBloc, AuctionDataState>(
      'GIVEN AuctionRepository returns data for auctions WHEN AuctionDataFetched event is added THEN emit [Loading, Exception] with the exception thrown',
      build: () {
        when(() => mockRepository.fetchAuctionDataByVin(any())).
        thenThrow(NetworkException('The request took too long to process, please try again shortly.'));
        return auctionDataBloc;
      },
      act: (bloc) => bloc.add(AuctionDataFetched(vin: 'vin')),
      expect: () => [
        AuctionDataStateLoading(),
        AuctionDataStateException(errorMessage: 'The request took too long to process, please try again shortly.'),
      ],
    );


  });
}
