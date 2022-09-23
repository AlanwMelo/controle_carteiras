import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  State<StatefulWidget> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _addButton(),
        _stockLines(
            paper: _leadingText(text: 'Papel'),
            amount: _leadingText(text: 'Quantidade'),
            boughtValue: _leadingText(text: 'Compra'),
            actualPrice: _leadingText(text: 'Atual'),
            dif: _leadingText(text: 'Diferença')),
        _stockLines(
            paper: Text('IRBR3'),
            amount: Text('42'),
            boughtValue: Text('11.3'),
            actualPrice: Center(child: Text('12.3')),
            dif: Text('10%'))
      ],
    );
  }

  _leadingText({required String text}) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  _stockLines(
      {required Widget paper,
      required Widget amount,
      required Widget boughtValue,
      required Widget actualPrice,
      required Widget dif}) {
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
      height: 30,
      color: Colors.blue,
      child: Row(
        children: [
          rows(child: paper),
          divisor,
          rows(child: amount),
          divisor,
          rows(child: boughtValue),
          divisor,
          rows(child: actualPrice),
          divisor,
          rows(child: dif),
        ],
      ),
    );
  }

  _addButton() {
    return Container(
      height: 30,
      width: 502,
      color: Colors.green,
      child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {  },
        child: const Text('Adcionar'),
      ),
    );
  }
}
