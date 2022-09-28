import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_carteiras/data/docManagement.dart';
import 'package:controle_carteiras/data/financeReader.dart';
import 'package:controle_carteiras/presentation/container.dart';
import 'package:controle_carteiras/presentation/fii/fiiDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FII extends StatefulWidget {
  final String month;
  final String year;
  final Function(List<double>) fiiAmount;

  const FII(
      {super.key,
      required this.month,
      required this.year,
      required this.fiiAmount});

  @override
  State<StatefulWidget> createState() => _FII();
}

class _FII extends State<FII> {
  List<FIIsData> fiiData = [];
  FinanceReader financeReader = FinanceReader();
  double fiiAmount = 0;
  double finalAmount = 0;
  bool loading = false;

  @override
  void initState() {
    _loadFIIs();
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
              actualPrice: _leadingText(text: 'Atual'),
              mediumPrice: _leadingText(text: 'Preço\nMédio'),
              dif: _leadingText(text: 'Dif')),
          ListView.builder(
              shrinkWrap: true,
              itemCount: fiiData.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                difText() {
                  if (fiiData[index].dif != 'Error') {
                    double value = double.parse(fiiData[index].dif);

                    return Text(
                      '${fiiData[index].dif}%',
                      style: TextStyle(
                          color: value < 0 ? Colors.redAccent : Colors.black),
                    );
                  } else {
                    return Text(fiiData[index].dif);
                  }
                }

                return Column(
                  children: [
                    _horizontalDivisor(),
                    InkWell(
                      onTap: () => _editItem(index),
                      onLongPress: () async {
                        if (!fiiData[index].valor.contains("Error")) {
                          fiiAmount = fiiAmount -
                              (double.parse(fiiData[index].quantidade) *
                                  double.parse(fiiData[index].medio));

                          finalAmount = finalAmount -
                              (double.parse(fiiData[index].quantidade) *
                                  double.parse(fiiData[index].valor));
                        }
                        await DocManagement().deleteFII(
                            fiiData[index].papel, widget.year, widget.month);
                        widget.fiiAmount([fiiAmount, finalAmount]);
                        fiiData.removeAt(index);
                      },
                      child: _stockLines(
                        paper: Text(fiiData[index].papel),
                        amount: Text(fiiData[index].quantidade),
                        actualPrice: Center(child: Text(fiiData[index].valor)),
                        mediumPrice: Text(fiiData[index].medio),
                        dif: difText(),
                      ),
                    )
                  ],
                );
              }),
        ],
      ),
    );
  }

  _leadingText({required String text}) {
    return Text(text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold));
  }

  _stockLines({
    required Widget paper,
    required Widget amount,
    required Widget mediumPrice,
    required Widget actualPrice,
    required Widget dif,
  }) {
    double columnWidth = 100;
    Widget divisor = Container(width: 0.5, color: Colors.black);

    rows({required Widget child}) {
      return Expanded(
        child: Container(
            color: Colors.lightBlueAccent.withOpacity(0.2),
            width: columnWidth,
            child: Center(child: child)),
      );
    }

    return SizedBox(
      height: 40,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                rows(child: paper),
                divisor,
                rows(child: amount),
                divisor,
                rows(child: mediumPrice),
                divisor,
                rows(child: actualPrice),
                divisor,
                rows(child: dif),
              ],
            ),
          ),
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
                FIIDialog().showStockDialog(context, (res) async {
                  await DocManagement().saveFII(res, widget.year, widget.month);
                  _loadFIIs();
                });
                setState(() {});
              },
              child: const Text('FIIs'),
            ),
    );
  }

  _horizontalDivisor() {
    return Container(width: 502, height: 0.5, color: Colors.black);
  }

  _loadFIIs() async {
    int counter = 0;
    QuerySnapshot fiiList =
        await DocManagement().getFIIs(widget.year, widget.month);

    for (var fii in fiiList.docs) {
      _loadingControl(true);
      Map data = fii.data() as Map;
      String lastValue = data['lastValue'].toString();
      String dif = 'Error';

      if (fiiData.indexWhere((element) =>
              element.papel == data['stock'].toString().toUpperCase()) ==
          -1) {
        if (data['lastValue'] == null) {
          lastValue = await financeReader.getStockLastValue(
              '${data['stock'].toString().toUpperCase()}.SA');
        }

        if (!lastValue.contains('Error')) {
          dif = _getDif(data['boughtValue'], lastValue);
          fiiAmount = fiiAmount + (data['amount'] * data['boughtValue']);
          finalAmount =
              finalAmount + (data['amount'] * double.parse(lastValue));
        }

        fiiData.add(FIIsData(
            data['stock'].toString().toUpperCase(),
            data['amount'].toInt().toString(),
            lastValue,
            data['boughtValue'].toString(),
            dif));
      }

      counter = counter + 1;
      if (counter == fiiData.length) {
        widget.fiiAmount([fiiAmount, finalAmount]);
        _loadingControl(false);
      }
    }
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

  _editItem(int index) {
    FIIDialog(editing: true, fii: fiiData[index]).showStockDialog(context,
        (res) async {
      await DocManagement().saveFII(res, widget.year, widget.month);
      finalAmount = finalAmount -
          (double.parse(fiiData[index].valor) *
              double.parse(fiiData[index].quantidade));
      fiiAmount = fiiAmount -
          (double.parse(fiiData[index].medio) *
              double.parse(fiiData[index].quantidade));
      fiiData.removeAt(index);
      _loadFIIs();
    });
  }
}

class FIIsData {
  final String papel;
  final String quantidade;
  final String valor;
  final String medio;
  final String dif;

  FIIsData(this.papel, this.quantidade, this.valor, this.medio, this.dif);
}
