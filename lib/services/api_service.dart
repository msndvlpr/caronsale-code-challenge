import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import '../models/auction_data.dart';
import '../models/vehicle_option.dart';
import 'cos_challenge.dart';

class ApiService {
  /// Returns:
  /// - An [AuctionData] object when the response is successful (status code 200).
  /// - A [List<VehicleOption>] when status code 300 is returned.
  /// - Throws an error for other cases.
  static Future<dynamic> fetchAuctionData({
    required String vin,
    required String userId,
  }) async {
    // (Optional) You could validate the VIN here again if needed.

    final uri = Uri.https('anyUrl'); // The URL is not critical because our MockClient simulates responses.
    final headers = {CosChallenge.user: userId};

    final Response response = await CosChallenge.httpClient.get(uri, headers: headers);

    if (response.statusCode == 200) {
      // Parse success JSON to AuctionData
      try {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return AuctionData.fromJson(jsonMap);
      } catch(e){
        print(e);
      }

    } else if (response.statusCode == 300) {
      // Parse JSON array of vehicle options
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => VehicleOption.fromJson(json)).toList();

    } else if (response.statusCode >= 400 && response.statusCode < 500) {
      // Parse error message and throw an exception or return an error object
      final Map<String, dynamic> jsonMap = jsonDecode(response.body);
      throw Exception(jsonMap['message'] ?? 'Client error');
    } else {
      throw Exception('Unexpected response: ${response.statusCode}');
    }
  }
}
