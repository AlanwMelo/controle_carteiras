import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FIIReserva extends StatefulWidget {
  const FIIReserva({super.key});

  @override
  State<StatefulWidget> createState() => _FIIReservaState();
}

class _FIIReservaState extends State<FIIReserva> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.lightBlueAccent.withOpacity(0.8),
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Column(
          children: [
            _addButton(),
            _stockLines(
              paper: _leadingText(text: 'Papel'),
              amount: _leadingText(text: 'Quantidade'),
              actualPrice: _leadingText(text: 'Atual'),
            ),
            _horizontalDivisor(),
            _stockLines(
              paper: Text('IRBR3'),
              amount: Text('42'),
              actualPrice: Center(child: Text('12.3')),
            )
          ],
        ),
      ),
    );
  }

  _leadingText({required String text}) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  _stockLines({
    required Widget paper,
    required Widget amount,
    required Widget actualPrice,
  }) {
    double columnWidth = 100;
    double columnPadding = 8;
    Widget divisor = Container(width: 0.5, color: Colors.black);

    rows({required Widget child}) {
      return Container(
          padding: EdgeInsets.all(columnPadding),
          width: columnWidth,
          child: Center(child: child));
    }

    return Container(
      height: 40,
      child: Row(
        children: [
          rows(child: paper),
          divisor,
          rows(child: amount),
          divisor,
          rows(child: actualPrice),
        ],
      ),
    );
  }

  _addButton() {
    return Container(
      height: 30,
      width: 301,
      color: Colors.green,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {},
        child: const Text('Adcionar'),
      ),
    );
  }

  _horizontalDivisor() {
    return Container(width: 301, height: 0.5, color: Colors.black);
  }
}
