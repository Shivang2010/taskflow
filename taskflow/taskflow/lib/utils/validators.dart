class Validators {
  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? validateEmail(String email) {
    if (email.trim().isEmpty) return 'Please enter your email';
    if (!_emailPattern.hasMatch(email.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String password) {
    if (password.isEmpty) return 'Please enter your password';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateConfirmPassword(String password, String confirm) {
    if (password != confirm) return 'Passwords do not match';
    return null;
  }

  static String? validateTitle(String title) {
    if (title.trim().isEmpty) return 'Please enter a title';
    if (title.trim().length > 100) {
      return 'Title must be 100 characters or less';
    }
    return null;
  }
}
