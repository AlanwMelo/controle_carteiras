class Stock {
  final String paper;
  final double amount;
  final double boughtValue;
  double? lastValue;

  Stock(
      {required this.paper,
      required this.amount,
      required this.boughtValue,
      this.lastValue});
}
