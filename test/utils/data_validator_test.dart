import 'package:caronsale_code_challenge/utils/data_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  group('isVinValid', () {

    test(
        'GIVEN an empty VIN WHEN validated THEN should return error message',
            () {
          final result = isVinValid('');
          expect(result, 'VIN number must be 17 characters');
        });

    test(
        'GIVEN a VIN shorter than 17 characters WHEN validated THEN should return error message',
            () {
          final result = isVinValid('1234567890ABCDE');
          expect(result, 'VIN number must be 17 characters');
        });

    test(
        'GIVEN a VIN longer than 17 characters WHEN validated THEN should return error message',
            () {
          final result = isVinValid('1234567890ABCDEFGHIJ');
          expect(result, 'VIN number must be 17 characters');
        });

    test(
        'GIVEN a VIN with illegal character WHEN validated THEN should return error message',
            () {
          final result = isVinValid('1234567890ABCD@FG');
          expect(result, 'Illegal character: @');
        });

    test(
        'GIVEN a VIN with valid characters but incorrect check digit WHEN validated THEN should return error message',
            () {
          final result = isVinValid('1HGCM82633A123456');
          expect(result, 'VIN number is in illegal format');
        });

    test(
        'GIVEN a valid VIN WHEN validated THEN should return null',
            () {
          final result = isVinValid('WBAYK510405N35485');
          expect(result, isNull);
        });
  });
}
