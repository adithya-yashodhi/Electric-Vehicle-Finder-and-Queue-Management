class EVPricingCalculator{

  /// -- calculate price based on tax
  static double calculateTotalPrice(double price, String port) {
    double taxRate = getTaxRateForPort(port);
    double taxAmount = price * taxRate;

    double totalPrice = price + taxAmount;
    return totalPrice;
  }

  /// calculate tax
  static String calculateTax(double price, port) {
    double taxRate = getTaxRateForPort(port);
    double taxAmount = price * taxRate;
    return taxAmount.toStringAsFixed(2);
  }

  static getTaxRateForPort(String port) {
    return 0.10;
  }

}