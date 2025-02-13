import 'package:network_api/network_api_service.dart';

class AuctionRepository {
  final NetworkApiService _networkApiService;

  AuctionRepository({NetworkApiService? networkApiService})
      : _networkApiService = networkApiService ?? NetworkApiService();

  Future<dynamic> fetchAuctionDataByVin(String vin, String userId) async {
    try {

      final data = await _networkApiService.getAuctionData(vin, userId);
      return data;

    } on NetworkException catch (e) {
      throw Exception(e.message);

    } on DataParsingException catch (_) {
      throw Exception('Error loading data, please contact the customer support team.');

    } catch (e) {
      throw Exception('Error loading data, please try again shortly.');

    }
  }

  Future<dynamic> fetchVehicleDataByExternalId(String eid, String userId) async {
    try {

      final data = await _networkApiService.getAuctionVehicle(eid, userId);
      return data;

    } on NetworkException catch (e) {
      throw Exception(e.message);

    } on DataParsingException catch (_) {
      throw Exception('Error loading data, please contact the customer support team.');

    } catch (e) {
      throw Exception('Error loading data, please try again shortly.');

    }
  }

}

class DataParsingException implements Exception {
  final String message;

  DataParsingException(this.message);
}
