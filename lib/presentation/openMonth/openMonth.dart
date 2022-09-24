import 'package:controle_carteiras/presentation/openMonth/FIIReserva.dart';
import 'package:controle_carteiras/presentation/openMonth/resume.dart';
import 'package:controle_carteiras/presentation/openMonth/stockList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenMonth extends StatefulWidget {
  const OpenMonth({super.key});

  @override
  State<StatefulWidget> createState() => _OpenMonthState();
}

class _OpenMonthState extends State<OpenMonth> {
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
        height: 160,
        color: Colors.green,
        child: Row(
          children: [Column()],
        ));
  }
}
