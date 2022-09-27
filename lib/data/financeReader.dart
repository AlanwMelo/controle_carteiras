import 'package:yahoo_finance_data_reader/yahoo_finance_data_reader.dart';

class FinanceReader {
  YahooFinanceDailyReader _yahooFinanceDailyReader = YahooFinanceDailyReader();

  getStockLastValue(String stock) async {
    List<dynamic> prices = await _yahooFinanceDailyReader.getDailyData(stock);

    if (prices.isNotEmpty) {
      double? price;
      if (prices[0]['open'].toDouble() == 0 &&
          prices[0]['close'].toDouble() != 0) {
        price = prices[0]['close'].toDouble();
      } else {
        price = prices[0]['open'].toDouble();
      }

      return price?.toStringAsFixed(2);
    } else {
      return 'Error';
    }
  }
}
