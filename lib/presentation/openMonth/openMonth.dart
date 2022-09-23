import 'package:controle_carteiras/presentation/openMonth/FIIReserva.dart';
import 'package:controle_carteiras/presentation/openMonth/stockList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenMonth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OpenMonthState();
}

class _OpenMonthState extends State<OpenMonth> {
  @override
  Widget build(BuildContext context) {
    EdgeInsets myMargin = const EdgeInsets.all(20);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 160, color: Colors.green, child: Row()),
            SizedBox(
                height: 1200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(margin: myMargin, child: const StockList()),
                    Container(
                        margin: myMargin,
                        color: Colors.orangeAccent,
                        child: Column()),
                    Container(
                        margin: myMargin,
                        child: const FIIReserva()),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
