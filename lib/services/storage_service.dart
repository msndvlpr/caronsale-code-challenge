import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String auctionDataKey = 'auctionData';

  static Future<void> saveAuctionData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(auctionDataKey, jsonEncode(data));
  }

  static Future<Map<String, dynamic>?> getAuctionData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(auctionDataKey);
    if (jsonString != null) {
      return jsonDecode(jsonString);
    }
    return null;
  }
}
