import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_carteiras/data/docManagement.dart';
import 'package:controle_carteiras/data/financeReader.dart';
import 'package:controle_carteiras/presentation/container.dart';
import 'package:controle_carteiras/presentation/fii/fiiDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FIIReserva extends StatefulWidget {
  final String month;
  final String year;
  final Function(double) fiiAmount;

  const FIIReserva(
      {super.key,
      required this.month,
      required this.year,
      required this.fiiAmount});

  @override
  State<StatefulWidget> createState() => _FIIReservaState();
}

class _FIIReservaState extends State<FIIReserva> {
  List<FIIData> fiiData = [];
  FinanceReader financeReader = FinanceReader();
  double fiiAmount = 0;
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
            amount: _leadingText(text: 'Quantidade'),
            actualPrice: _leadingText(text: 'Atual/Final'),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: fiiData.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    _horizontalDivisor(),
                    InkWell(
                      onTap: () {},
                      onLongPress: () async {
                        if (!fiiData[index].valor.contains("Error")) {
                          fiiAmount = fiiAmount -
                              (double.parse(fiiData[index].quantidade) *
                                  double.parse(fiiData[index].valor));
                        }
                        await DocManagement().deleteFII(
                            fiiData[index].papel, widget.year, widget.month);
                        widget.fiiAmount(fiiAmount);
                        fiiData.removeAt(index);
                      },
                      child: _stockLines(
                        paper: Text(fiiData[index].papel),
                        amount: Text(fiiData[index].quantidade),
                        actualPrice: Center(child: Text(fiiData[index].valor)),
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
    required Widget actualPrice,
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
              child: const Text('FII Reserva'),
            ),
    );
  }

  _horizontalDivisor() {
    return Container(width: 502, height: 0.5, color: Colors.black);
  }

  _loadFIIs() async {
    _loadingControl(true);
    QuerySnapshot fiiList =
        await DocManagement().getFIIs(widget.year, widget.month);

    for (var fii in fiiList.docs) {
      Map data = fii.data() as Map;
      String lastValue = data['lastValue'].toString();

      if (fiiData.indexWhere((element) =>
              element.papel == data['stock'].toString().toUpperCase()) ==
          -1) {
        if (data['lastValue'] == null) {
          lastValue = await financeReader.getStockLastValue(
              '${data['stock'].toString().toUpperCase()}.SA');
        }

        if (!lastValue.contains('Error')) {
          fiiAmount = fiiAmount + (data['amount'] * double.parse(lastValue));
        }

        fiiData.add(FIIData(data['stock'].toString().toUpperCase(),
            data['amount'].toInt().toString(), lastValue));
      }

      setState(() {});
    }
    widget.fiiAmount(fiiAmount);
    _loadingControl(false);
  }

  _loadingControl(bool bool) {
    setState(() {
      loading = bool;
    });
  }
}

class FIIData {
  final String papel;
  final String quantidade;
  final String valor;

  FIIData(this.papel, this.quantidade, this.valor);
}
