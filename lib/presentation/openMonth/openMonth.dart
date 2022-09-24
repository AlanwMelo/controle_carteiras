import 'package:controle_carteiras/presentation/openMonth/FIIReserva.dart';
import 'package:controle_carteiras/presentation/openMonth/resume.dart';
import 'package:controle_carteiras/presentation/openMonth/stockList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yahoofin/yahoofin.dart';

class OpenMonth extends StatefulWidget {
  const OpenMonth({super.key});

  @override
  State<StatefulWidget> createState() => _OpenMonthState();
}

class _OpenMonthState extends State<OpenMonth> {

  @override
  void initState() {
   _yfin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EdgeInsets myMargin = const EdgeInsets.all(20);

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _mainInfo(),
            SizedBox(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(margin: myMargin, child: const StockList()),
                Container(margin: myMargin, child: const Resume()),
                Container(margin: myMargin, child: const FIIReserva()),
              ],
            )),
          ],
        ),
      ),
    );
  }

  _mainInfo() {
    return Container(
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.7),
            border: Border(
                bottom: BorderSide(
                    width: 5, color: Colors.lightBlueAccent.withOpacity(0.2)))),
        height: 160,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'R\$ 7542',
                    style: TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Saldo inicial',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'R\$ 7982',
                    style: TextStyle(
                        fontSize: 60,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Saldo final',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text('+ 24%',
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 60,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ));
  }

  Future<void> _yfin() async {
    final yfin = YahooFin();
    StockInfo info = yfin.getStockInfo(ticker: "GOOG");
    StockQuote priceChange = await yfin.getPriceChange(stockInfo: info);
    /*StockQuote price = await yfin.getPrice(stockInfo: info);
    print(price.props);*/

  }
}
