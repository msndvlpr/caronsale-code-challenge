import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';


const publicKeyPem = '''
  -----BEGIN PUBLIC KEY-----
  MY_RSA_PUBLIC_KEY_SAMPLE
  -----END PUBLIC KEY-----
  ''';

class RSACrypto {
  final String publicKeyString;

  RSACrypto(this.publicKeyString);

  /// Encrypts the given [text] using the public RSA key
  String encrypt(String text) {
    final publicKey = RSAKeyParser().parse(publicKeyString) as RSAPublicKey;
    final encrypter = Encrypter(RSA(publicKey: publicKey));

    final encrypted = encrypter.encrypt(text);
    return encrypted.base64;
  }
}
