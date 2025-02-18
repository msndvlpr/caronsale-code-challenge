import 'dart:async';
import 'dart:convert';

import 'package:auction_repository/auction_repository.dart';
import 'package:network_api/network_api_service.dart';
import 'package:secure_storage_api/secure_storage_api.dart';


class AuctionRepository {
  final NetworkApiService _networkApiService;
  final SecureStorageApi _secureStorageApi;

  AuctionRepository({NetworkApiService? networkApiService, SecureStorageApi? secureStorageApi})
      : _networkApiService = networkApiService ?? NetworkApiService(),
        _secureStorageApi = secureStorageApi ?? SecureStorageApi();

  Future<dynamic> fetchAuctionDataByVin(String vin) async {

    final keyAuctionData = 'KEY_AUCTION_DATA_$vin';
    final keyVehicleOptions = 'KEY_VEHICLE_OPTIONS_$vin';

    bool useCache = bool.parse(await _secureStorageApi.read(storageKeyUseCache) ?? 'false');
    final userId = await _secureStorageApi.read(storageKeyUserId);
    final token = await _secureStorageApi.read(storageKeyToken);

    try {
      final data = await _networkApiService.getAuctionData(vin, userId!, token!);
        // Store data locally persistently for cache feature
        if(data is AuctionData){
          String auctionDataJson = jsonEncode(data.toJson());
          await _secureStorageApi.write(keyAuctionData, auctionDataJson);

        } else if(data is VehicleOptionItems){
          String vehicleOptionItems = jsonEncode(data.toJson());
          await _secureStorageApi.write(keyVehicleOptions, vehicleOptionItems);

        } else {
          if(useCache) {
            throw NetworkException('An unknown error occurred, please try again shortly.');
          } else {
            return data;
          }
        }
      return data;

    } on NetworkException catch (e) {

      if(useCache) {
        // If the response is any kind of error then read from cache and return cached data instead
        final json = await _secureStorageApi.read(keyVehicleOptions);
        if (json != null) {
          final cachedVehicleOptions = VehicleOptionItems.fromJson(jsonDecode(json));
          return cachedVehicleOptions;
        } else {
          final json = await _secureStorageApi.read(keyAuctionData);
          if (json != null) {
            final cachedAuctionData = AuctionData.fromJson(jsonDecode(json));
            return cachedAuctionData;
          }
        }
      }
      rethrow;

    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> fetchVehicleDataByExternalId(String eid) async {

    final keyAuctionData = 'KEY_AUCTION_DATA_$eid';
    bool useCache = bool.parse(await _secureStorageApi.read(storageKeyUseCache) ?? 'false');
    final userId = await _secureStorageApi.read(storageKeyUserId);
    final token = await _secureStorageApi.read(storageKeyToken);

    try {
      final data = await _networkApiService.getAuctionVehicle(eid, userId!, token!);
      // Store data locally persistently for cache feature
      if(data is AuctionData){
        String auctionDataJson = jsonEncode(data.toJson());
        await _secureStorageApi.write(keyAuctionData, auctionDataJson);

      } else {
        if(useCache) {
          throw NetworkException('An unknown error occurred, please try again shortly.');
        } else {
          return data;
        }
      }
      return data;

    } on NetworkException catch (e) {

      if(useCache) {
        // If the response is any kind of error then read from cache and return cached data instead
        final json = await _secureStorageApi.read(keyAuctionData);
        if (json != null) {
          final cachedAuctionData = AuctionData.fromJson(jsonDecode(json));
          return cachedAuctionData;
        }
      }
      rethrow;

    } catch (e) {
      rethrow;
    }
  }

}

class DataParsingException implements Exception {
  final String message;

  DataParsingException(this.message);
}
