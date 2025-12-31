class Validator {
  static String? validateEmail(String? email) {
    if (email == null) {
      return 'Please enter an email address';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(email)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.length < 6) {
      return 'Password must be at least 6 symbols';
    }

    return null;
  }

  static String? validateRepeatPassword(
    String? password,
    String? repeatPassword,
  ) {
    if (password != repeatPassword) {
      return 'Passwords must be equal';
    }

    return null;
  }

  static String? validateUsername(String? username) {
    if (username == null || username.length < 3) {
      return 'Username must be at least 3 symbols';
    }

    return null;
  }
}
