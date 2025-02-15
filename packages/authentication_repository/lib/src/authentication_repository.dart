import 'package:authentication_repository/src/rsa_crypto.dart';
import 'package:network_api/network_api_service.dart';
import 'package:secure_storage_repository/secure_storage_repository.dart';

import 'constants.dart';

class AuthenticationRepository {
  final NetworkApiService _networkApiService;
  final SecureStorageRepository _secureStorageRepository;

  AuthenticationRepository({
    NetworkApiService? networkApiService,
    SecureStorageRepository? secureStorageRepository
  })
      : _networkApiService = networkApiService ?? NetworkApiService(),
        _secureStorageRepository = secureStorageRepository ?? SecureStorageRepository();

  Future<String> authenticateUserByCredentials(
      String username, String password) async {
    try {
      // Encrypt the username and password before sending to backend
      String encryptedUserCredentials = encryptData("$username:$password");

      final token = await _networkApiService.postUserAuthenticationInfo(encryptedUserCredentials);
      if (token.isNotEmpty) {

        // Storing username and successful token resolution to the local secure storage
        await _secureStorageRepository.write(storageKeyToken, token);
        await _secureStorageRepository.write(storageKeyUserId, username);

        return token;
      } else {
        throw Exception("Error authenticating user, please try again shortly.");

      }
    } on NetworkException catch (e) {
      throw Exception(e.message);

    } on DataParsingException catch (_) {
      throw Exception('Error authenticating user, please contact the customer support team.');

    } catch (e) {
      throw Exception('Error authenticating user, please try again shortly.');

    }
  }
}

class DataParsingException implements Exception {
  final String message;

  DataParsingException(this.message);
}
