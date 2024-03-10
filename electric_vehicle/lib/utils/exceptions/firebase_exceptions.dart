class EVFirebaseException implements Exception {
  final String code;
  //final String message;

  EVFirebaseException(this.code);

  String get message {
    switch(code) {
      case 'unknown':
        return 'An unknown firebase error occurred. Please try again.';
      case 'invalid-custom-token':
        return 'The custom token format is incorrect. Please check your custom token.';
      case 'custom-token-mismatch':
        return 'The custom token corresponds to a different audience.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'user-not-found':
        return 'No user found for the given email or UID';
      case 'email-already-in-use':
        return 'The email address is already registered. Please use a different email.';
      case 'invalid-email':
        return 'The email address provided is invalid. Please enter a valid email.';
      case 'weak-password':
        return 'The password is too weak. Please choose a stronger password.';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try again.';
      case 'provider-already-linked':
        return 'The account is already linked with another provider.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Contact support for assistance.';
      case 'captcha-check-failed':
        return 'The reCAPTCHA responsible is invalid. Please try again.';
      case 'key-chain-error':
        return 'A keychain error occurred. Please check the keychain and try again.';
      case 'internal-error':
        return 'An internal authentication error occurred. Please try again later.';
      default:
        return 'An unexpected firebase error occurred.Please try again.';
    }
  }
}