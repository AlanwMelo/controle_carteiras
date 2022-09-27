import 'package:controle_carteiras/presentation/openMonth/fii/FIIReserva.dart';
import 'package:controle_carteiras/presentation/openMonth/resume.dart';
import 'package:controle_carteiras/presentation/openMonth/stock/stockList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenMonth extends StatefulWidget {
  final String month;
  final String year;

  const OpenMonth({super.key, required this.month, required this.year});

  @override
  State<StatefulWidget> createState() => _OpenMonthState();
}

class _OpenMonthState extends State<OpenMonth> {
  String initialAmount = '-';
  String lastAmount = '-';
  String amountDif = '-';
  double initialDouble = 0;
  double finalDouble = 0;
  double backupAmount = 0;

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
                    child: Resume(
                      initialValue: initialDouble,
                      finalValue: finalDouble,
                      backupAmount: backupAmount,
                    )),
                Container(
                    margin: myMargin,
                    child: StockList(
                      month: widget.month,
                      year: widget.year,
                      applicationsResume: (applicationsResume) {
                        _refreshResume(applicationsResume);
                      },
                    )),
                Container(
                    margin: myMargin,
                    child: FIIReserva(
                      month: widget.month,
                      year: widget.year,
                      fiiAmount: (amount) {
                        backupAmount = amount;
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

  _refreshResume(List<double> applicationsResume) {
    initialAmount = applicationsResume[0].toStringAsFixed(2);
    lastAmount = applicationsResume[1].toStringAsFixed(2);

    initialDouble = applicationsResume[0];
    finalDouble = applicationsResume[1];

    double dif = applicationsResume[1] - applicationsResume[0];
    double percentage = dif / applicationsResume[0] * 100;

    if (dif != 0) {
      amountDif = percentage.toStringAsFixed(0);
    } else {
      amountDif = '-';
    }
    setState(() {});
  }
}
