import 'package:controle_carteiras/data/formatText.dart';
import 'package:controle_carteiras/presentation/fii/FII.dart';
import 'package:controle_carteiras/presentation/stock/stockList.dart';
import 'package:flutter/material.dart';

class MainDoc extends StatefulWidget {
  const MainDoc({super.key});

  @override
  State<StatefulWidget> createState() => _MainDocState();
}

class _MainDocState extends State<MainDoc> {
  String initialAmount = '-';
  String lastAmount = '-';
  String amountDif = '-';
  double initialDouble = 0;
  double finalDouble = 0;
  double fiiFinalDouble = 0;
  double fiiInitialDouble = 0;
  double stockFinalDouble = 0;
  double stockInitialDouble = 0;

  @override
  void initState() {
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
                child: Column(
              children: [
                Container(
                    margin: myMargin,
                    child: StockList(
                      month: '0',
                      year: 'resume',
                      applicationsResume: (applicationsResume) {
                        stockInitialDouble = applicationsResume[0];
                        stockFinalDouble = applicationsResume[1];
                        _refreshResume();
                      },
                    )),
                Container(
                    margin: myMargin,
                    child: FII(
                      month: '0',
                      year: 'resume',
                      fiiAmount: (amount) {
                        fiiInitialDouble = amount[0];
                        fiiFinalDouble = amount[1];
                        _refreshResume();
                        setState(() {});
                      },
                    )),
              ],
            )),
          ],
        ),
      ),
    );
  }

  _mainInfo() {
    setAmountText();

    difText() {
      Color textColor = Colors.greenAccent;
      if (amountDif != '-') {
        if (int.parse(amountDif) < 0) {
          textColor = Colors.redAccent;
        }
      }

      return Text('$amountDif%',
          style: TextStyle(
              color: textColor, fontSize: 18, fontWeight: FontWeight.bold));
    }

    return Container(
        decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.7),
            border: Border(
                bottom: BorderSide(
                    width: 5, color: Colors.lightBlueAccent.withOpacity(0.2)))),
        height: 90,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        initialAmount,
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Saldo inicial',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        lastAmount,
                        style: const TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Saldo final',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              difText(),
            ],
          ),
        ));
  }

  _refreshResume() {
    double dif = (fiiFinalDouble + stockFinalDouble) -
        (fiiInitialDouble + stockInitialDouble);
    double percentage = dif / (fiiInitialDouble + stockInitialDouble) * 100;

    if (dif != 0) {
      amountDif = percentage.toStringAsFixed(0);
    } else {
      amountDif = '-';
    }
    setState(() {});
  }

  setAmountText() {
    double initial = fiiInitialDouble + stockInitialDouble;
    double last = fiiFinalDouble + stockFinalDouble;

    initialAmount = FormatText().setValueTextCommas(initial);
    lastAmount = FormatText().setValueTextCommas(last);
  }
}
