import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:network_api/src/mock_http_auth_handler.dart';
import 'package:network_api/src/model/error_response.dart';
import 'package:network_api/src/model/vehicle_option_items.dart';
import 'mock_http_handler.dart';
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
      final uri = Uri.https(baseUrl, '/api/vin-lookup', queryParams);
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
      final uri = Uri.https(baseUrl, '/api/vehicle-auction', queryParams);
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
        throw NetworkException('There was an issue processing your request. Please try again shortly.');

      }
    } on SocketException {
      throw NetworkException('No Internet connection, please check your network status.');

    } on TimeoutException {
      throw NetworkException('The request took too long to process, please try again shortly.');

    } catch (e) {
      debugPrint('error: $e');
      throw NetworkException('Error loading data, please try again shortly.');

    }
  }

  Future<String> postUserAuthenticationInfo(String credentials) async {
    try {

      final body = jsonEncode({'auth': credentials});
      final uri = Uri.https(baseUrl, '/api/login');
      final headers = {'Content-Type': 'application/json'};
      final timeOut = const Duration(seconds: 10);
      final loginResponse = await MockHttpAuthHandler.httpClient.post(uri, headers: headers, body: body).timeout(timeOut);

      if (loginResponse.statusCode == 200) {
        // Parse success JSON to login data
        final token = jsonDecode(loginResponse.body)['token'];
        return token;

      } else if (loginResponse.statusCode == 401 || loginResponse.statusCode == 403) {
        final error = jsonDecode(loginResponse.body)['message'];
        throw NetworkException(error);

      } else {
        throw NetworkException('There was an issue processing your request, please try again shortly.');
      }
    } on SocketException {
      throw NetworkException('No Internet connection, please check your network status.');

    } on TimeoutException {
      throw NetworkException('The request took too long to process, please try again shortly.');

    } on NetworkException catch (e) {
      throw NetworkException(e.message);

    }
  }
}
