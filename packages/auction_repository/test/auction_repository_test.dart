import 'dart:convert';

import 'package:auction_repository/auction_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_api/network_api_service.dart';
import 'package:secure_storage_api/secure_storage_api.dart';

class MockNetworkApiService extends Mock implements NetworkApiService {}

class MockSecureStorageApi extends Mock implements SecureStorageApi {}

void main() {

  late MockNetworkApiService mockNetworkApiService;
  late MockSecureStorageApi mockSecureStorageApi;
  late AuctionRepository auctionRepository;

  late AuctionData auctionData;

  const storageKeyToken = "KEY_STORE_TOKEN";
  const storageKeyUserId = "KEY_STORE_USERID";

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

  setUp(() {
    mockNetworkApiService = MockNetworkApiService();
    mockSecureStorageApi = MockSecureStorageApi();
    auctionRepository = AuctionRepository(networkApiService: mockNetworkApiService, secureStorageApi: mockSecureStorageApi);

    auctionData = AuctionData.fromJson(jsonDecode(jsonBody200Response));
    registerFallbackValue('fallback-value');
  });

  group('fetchAuctionDataByVin', () {

    test(
      'GIVEN AuctionRepository WHEN vin is provided THEN should return auction data',
          () async {
        when(() => mockNetworkApiService.getAuctionData('vin', 'userid', 'token'))
            .thenAnswer((_) async => auctionData);

        when(() => mockSecureStorageApi.read(storageKeyUseCache))
            .thenAnswer((_) async => Future.value('false'));
        when(() => mockSecureStorageApi.read(storageKeyUserId))
            .thenAnswer((_) async => Future.value('userid'));
        when(() => mockSecureStorageApi.read(storageKeyToken))
            .thenAnswer((_) async => Future.value('token'));

        when(() => mockSecureStorageApi.write(any(), any()))
            .thenAnswer((_) async => Future.value());

        final data = await auctionRepository.fetchAuctionDataByVin('vin');

        expect(data, isNotNull);

        verify(() => mockSecureStorageApi.read(any())).called(3);
        verify(() => mockNetworkApiService.getAuctionData('vin', 'userid', 'token')).called(1);
        verify(() => mockSecureStorageApi.write(any(), any())).called(1);
      },
    );

  });
}
