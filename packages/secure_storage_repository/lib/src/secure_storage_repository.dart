import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageRepository {

  final FlutterSecureStorage _flutterSecureStorage;

  SecureStorageRepository({FlutterSecureStorage? flutterSecureStorage})
      : _flutterSecureStorage = flutterSecureStorage ?? FlutterSecureStorage();


  Future<String?> read(String key) async {
    return await _flutterSecureStorage.read(key: key);
  }

  Future<void> write(String key, String value) async {
    await _flutterSecureStorage.write(key: key, value: value);
  }

  Future<void> delete(String key) async {
    await _flutterSecureStorage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _flutterSecureStorage.deleteAll();
  }
}
