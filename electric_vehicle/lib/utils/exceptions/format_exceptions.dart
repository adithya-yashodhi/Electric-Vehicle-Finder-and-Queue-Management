class EVFormatException implements Exception{
  final String message;

  const EVFormatException([this.message = 'An unexpected format error occurred. Please check your input']);

  factory EVFormatException.fromMessage(String message) {
    return EVFormatException(message);
  }

  String get formattedMessage => message;

  factory EVFormatException.fromCode(String code) {
    switch(code) {
      case 'invalid-email-format':
        return const EVFormatException('The email address format is invalid. Please enter a valid email.');
      case 'invalid-phone-number-format':
        return const EVFormatException('The provided phone number format is invalid. Please enter a valid number.');
      case 'invalid-date-format':
        return const EVFormatException('The date format is invalid. Please enter a valid date.');
      case 'invalid-url-format':
        return const EVFormatException('The URL format is invalid. Please enter a valid URL.');
      case 'invalid-credit-card-format':
        return const EVFormatException('The credit card format is invalid. Please enter a valid credit card number.');
      case 'invalid-numeric-format':
        return const EVFormatException('The input should be valid numeric format.');
      default:
        return const EVFormatException();
    }
  }
}