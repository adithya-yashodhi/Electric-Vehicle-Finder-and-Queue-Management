class EVPlatformException implements Exception {
  final String code;
  //final String message;

  EVPlatformException(this.code);

  String get message {
    switch(code) {
      case 'INVALID-LOGIN-CREDENTIALS':
        return 'iInvalid login credentials. Please double check your information.';
      case 'too-many-requests':
        return 'Too many requests. Please try again later.';
      case 'invalid-argument':
        return 'Invalid argument provided to the authentication method.';
      case 'invalid-password':
        return 'Incorrect password. Please try again later.';
      case 'invalid-phone-number':
        return 'The provided phone number is invalid.';
      case 'session-cookie-expired':
        return 'The firebase session cookie has expired. Please sign in again';
      case 'uid-already-exists':
        return 'The provided user ID is already in use by another user.';
      case 'sign-in-failed':
        return 'sign-in failed. please try again.';
      case 'network-request-failed':
        return 'Network request failed. Please check your internet connection.';
      case 'operation-not-allowed':
        return 'This operation is not allowed. Contact support for assistance.';
      case 'internal-error':
        return 'An internal authentication error occurred. Please try again later.';
      default:
        return 'An unexpected platform error occurred.Please try again.';
    }
  }
}