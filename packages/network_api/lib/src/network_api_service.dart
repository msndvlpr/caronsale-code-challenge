import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:network_api/src/model/error_response.dart';
import 'package:network_api/src/model/vehicle_option_items.dart';
import 'cos_challenge.dart';
import 'model/auction_data.dart';

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class NetworkApiService {

  final String baseUrl;
  NetworkApiService({this.baseUrl = "some-mocked-base-url"});

  Future<dynamic> getAuctionData(String vin, String userId) async {
    try {
      final queryParams = {'vin': vin};
      final uri = Uri.https(baseUrl, '/api/endpoint1', queryParams);
      final headers = {CosChallenge.user: userId};
      final timeOut = const Duration(seconds: 10);
      final response = await CosChallenge.httpClient.get(uri, headers: headers).timeout(timeOut);

      final jsonMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Parse success JSON to AuctionData
        return AuctionData.fromJson(jsonMap);

      } else if (response.statusCode == 300) {
        // Parse JSON array of vehicle options
        VehicleOptionItems vehicleOptions = VehicleOptionItems.fromJson(response.body);
        return vehicleOptions;

      } else if (response.statusCode == 400) {
        // Parse error message and return an exception or return an error object
        return ErrorResponse.fromJson(jsonMap);

      } else {
        debugPrint('Error ${response.statusCode}: ${response.reasonPhrase}');
        throw NetworkException('Error loading the data, please try again in a moment.');

      }
    } on SocketException {
      throw NetworkException('No Internet connection, please check your network.');

    } on TimeoutException {
      throw NetworkException('The request took too long to process, please try again in a moment.');

    } catch (e) {
      debugPrint('error: $e');
      throw NetworkException('Error loading data, please try again in a moment.');

    }
  }

  Future<dynamic> getAuctionVehicle(String eid, String userId) async {
    try {
      final queryParams = {'eid': eid};
      final uri = Uri.https(baseUrl, '/api/endpoint2', queryParams);
      final headers = {CosChallenge.user: userId};
      final timeOut = const Duration(seconds: 10);
      final response = await CosChallenge.httpClient.get(uri, headers: headers).timeout(timeOut);

      final jsonMap = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // Parse success JSON to AuctionData
        return AuctionData.fromJson(jsonMap);

      } else if (response.statusCode == 400) {
        // Parse error message and return an exception or return an error object
        return ErrorResponse.fromJson(jsonMap);

      } else {
        debugPrint('Error ${response.statusCode}: ${response.reasonPhrase}');
        throw NetworkException('Error loading the data, please try again in a moment.');

      }
    } on SocketException {
      throw NetworkException('No Internet connection, please check your network.');

    } on TimeoutException {
      throw NetworkException('The request took too long to process, please try again in a moment.');

    } catch (e) {
      debugPrint('error: $e');
      throw NetworkException('Error loading data, please try again in a moment.');

    }
  }
}
