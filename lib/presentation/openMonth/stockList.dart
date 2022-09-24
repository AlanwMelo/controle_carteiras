import 'package:controle_carteiras/presentation/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StockList extends StatefulWidget {
  const StockList({super.key});

  @override
  State<StatefulWidget> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  List<StockData> stockData = [];

  @override
  void initState() {
    stockData.add(StockData('VAL3', '12', '100', '112', '12%'));
    stockData.add(StockData('VAL3', '12', '100', '112', '12%'));
    stockData.add(StockData('VAL3', '12', '100', '112', '12%'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BeautifulContainer(
      color: Colors.lightBlueAccent.withOpacity(0.5),
      child: Column(
        children: [
          _addButton(),
          _stockLines(
              paper: _leadingText(text: 'Papel'),
              amount: _leadingText(text: 'Qtd.'),
              boughtValue: _leadingText(text: 'Compra'),
              actualPrice: _leadingText(text: 'Atual'),
              dif: _leadingText(text: 'Diferença')),
          ListView.builder(
              shrinkWrap: true,
              itemCount: stockData.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _horizontalDivisor(),
                    _stockLines(
                        paper: Text(stockData[index].papel),
                        amount: Text(stockData[index].quantidade),
                        boughtValue: Text(stockData[index].valorCompra),
                        actualPrice:
                            Center(child: Text(stockData[index].valorAtual)),
                        dif: Text(stockData[index].dif))
                  ],
                );
              }),
        ],
      ),
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
    Widget divisor = Container(width: 0.5, color: Colors.black);

    rows({required Widget child}) {
      return Expanded(
        child: Container(
            color: Colors.lightBlueAccent.withOpacity(0.2),
            child: Center(child: child)),
      );
    }

    return Container(
      height: 40,
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {},
        child: const Text('Papeis do mês'),
      ),
    );
  }

  _horizontalDivisor() {
    return Container(width: 502, height: 0.5, color: Colors.black);
  }
}

class StockData {
  final String papel;
  final String quantidade;
  final String valorCompra;
  final String valorAtual;
  final String dif;

  StockData(
      this.papel, this.quantidade, this.valorCompra, this.valorAtual, this.dif);
}
