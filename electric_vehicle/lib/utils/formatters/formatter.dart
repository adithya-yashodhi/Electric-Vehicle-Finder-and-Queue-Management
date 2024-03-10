import 'package:intl/intl.dart';

class EVFormatter {
  static String formatDate(DateTime? date){
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date); // customize the date format
  }

  static String formatCurrency(double amount) {
    return NumberFormat.currency(locale: 'si_LK', symbol: 'රු').format(amount);
  }

  static String formatPhoneNumber(String phoneNumber) {
    if(phoneNumber.length == 10){
      return '(${phoneNumber.substring(0, 3)}) ${phoneNumber.substring(3, 6)} ${phoneNumber.substring(6)}';
    }
    return phoneNumber;
  }
}