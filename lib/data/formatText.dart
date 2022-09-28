class FormatText {
  setValueTextCommas(double value) {
    String formatted;
    if (value > 1000) {
      int thousandDigits = value ~/ 1000;
      formatted =
          '$thousandDigits,${value.toStringAsFixed(2).substring(thousandDigits.toString().length)}';
    } else {
      formatted = (value).toStringAsFixed(2);
    }
    return formatted;
  }
}
