import 'package:flutter_test/flutter_test.dart';
import 'package:taskflow/utils/validators.dart';

void main() {
  group('validateEmail', () {
    test('empty email returns an error', () {
      expect(Validators.validateEmail(''), 'Please enter your email');
    });

    test('invalid email returns an error', () {
      expect(
        Validators.validateEmail('not-an-email'),
        'Enter a valid email address',
      );
    });

    test('valid email returns null', () {
      expect(Validators.validateEmail('jane@example.com'), isNull);
    });
  });

  group('validatePassword', () {
    test('empty password returns an error', () {
      expect(Validators.validatePassword(''), 'Please enter your password');
    });

    test('short password returns an error', () {
      expect(
        Validators.validatePassword('12345'),
        'Password must be at least 6 characters',
      );
    });

    test('valid password returns null', () {
      expect(Validators.validatePassword('secret1'), isNull);
    });
  });

  group('validateConfirmPassword', () {
    test('different passwords return an error', () {
      expect(
        Validators.validateConfirmPassword('secret1', 'secret2'),
        'Passwords do not match',
      );
    });

    test('matching passwords return null', () {
      expect(Validators.validateConfirmPassword('secret1', 'secret1'), isNull);
    });
  });
}
