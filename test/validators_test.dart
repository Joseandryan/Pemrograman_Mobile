import 'package:flutter_test/flutter_test.dart';
import 'package:secure_http/utils/validators.dart';

void main() {
  group('Validators Unit Test', () {
    test('isValidEmail mengembalikan true untuk email valid', () {
      expect(Validators.isValidEmail('test@gmail.com'), isTrue);
    });

    test('isValidEmail mengembalikan false untuk email invalid', () {
      expect(Validators.isValidEmail('testgmail.com'), isFalse);
    });

    test('sanitize membersihkan karakter HTML berbahaya', () {
      final dirtyInput = '<script>alert("XSS")</script>';
      final cleanInput = Validators.sanitize(dirtyInput);
      expect(cleanInput, contains('&lt;script&gt;'));
    });

    test('validatePhone validasi angka 10-13 digit', () {
      expect(Validators.validatePhone('081234567890'), isTrue);
      expect(Validators.validatePhone('123'), isFalse);
    });
  });
}
