import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_carteiras/data/docManagement.dart';
import 'package:controle_carteiras/data/financeReader.dart';
import 'package:controle_carteiras/presentation/container.dart';
import 'package:controle_carteiras/presentation/openMonth/stock/stockDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StockList extends StatefulWidget {
  final String month;
  final String year;

  const StockList({super.key, required this.month, required this.year});

  @override
  State<StatefulWidget> createState() => _StockListState();
}

class _StockListState extends State<StockList> {
  bool loading = false;
  FinanceReader financeReader = FinanceReader();
  List<StockData> stockData = [];

  @override
  void initState() {
    _loadStocks();
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
              actualPrice: _leadingText(text: 'Atual/Venda'),
              dif: _leadingText(text: 'Diferença')),
          ListView.builder(
              shrinkWrap: true,
              itemCount: stockData.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                difText() {
                  if (stockData[index].dif != 'Error') {
                    double value = double.parse(stockData[index].dif);

                    return Text(
                      '${stockData[index].dif}%',
                      style: TextStyle(
                          color: value < 0 ? Colors.redAccent : Colors.black),
                    );
                  } else {
                    return Text(stockData[index].dif);
                  }
                }

                return Column(
                  children: [
                    _horizontalDivisor(),
                    _stockLines(
                        paper: Text(stockData[index].papel),
                        amount: Text(stockData[index].quantidade),
                        boughtValue: Text(stockData[index].valorCompra),
                        actualPrice:
                            Center(child: Text(stockData[index].valorAtual)),
                        dif: difText())
                  ],
                );
              }),
        ],
      ),
    );
  }

  _leadingText({required String text}) {
    return Text(
        textAlign: TextAlign.center,
        text,
        style: const TextStyle(fontWeight: FontWeight.bold));
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

    return SizedBox(
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
      child: loading
          ? const Center(
              child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )))
          : ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                StockDialog().showStockDialog(context, (res) async {
                  await DocManagement()
                      .saveStock(res, widget.year, widget.month);
                  _loadStocks();
                });
              },
              child: const Text('Papeis do mês'),
            ),
    );
  }

  _horizontalDivisor() {
    return Container(width: 502, height: 0.5, color: Colors.black);
  }

  _loadStocks() async {
    _loadingControl(true);
    QuerySnapshot stocksList =
        await DocManagement().getStocks(widget.year, widget.month);

    for (var stock in stocksList.docs) {
      Map data = stock.data() as Map;
      String lastValue = data['lastValue'].toString();
      String dif = 'Error';

      if (stockData.indexWhere((element) =>
              element.papel == data['stock'].toString().toUpperCase()) ==
          -1) {
        if (data['lastValue'] == null) {
          lastValue = await financeReader.getStockLastValue(
              '${data['stock'].toString().toUpperCase()}.SA');
        }
        if (lastValue != 'Error') {
          dif = _getDif(data['boughtValue'], lastValue);
        }

        stockData.add(StockData(
            data['stock'].toString().toUpperCase(),
            data['amount'].toString(),
            data['boughtValue'].toString(),
            lastValue,
            dif));
      }

      setState(() {});
    }
    _loadingControl(false);
  }

  _loadingControl(bool bool) {
    setState(() {
      loading = bool;
    });
  }

  _getDif(originalValue, String lastValue) {
    double dif = double.parse(lastValue) - originalValue;
    double percentage = dif / originalValue * 100;

    return percentage.toStringAsFixed(2);
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
