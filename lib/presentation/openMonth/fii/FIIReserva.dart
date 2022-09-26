import 'package:controle_carteiras/data/docManagement.dart';
import 'package:controle_carteiras/presentation/container.dart';
import 'package:controle_carteiras/presentation/openMonth/fii/fiiDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FIIReserva extends StatefulWidget {
  final String month;
  final String year;

  const FIIReserva({super.key, required this.month, required this.year});

  @override
  State<StatefulWidget> createState() => _FIIReservaState();
}

class _FIIReservaState extends State<FIIReserva> {
  List<FIIData> fiiData = [];
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
                    _stockLines(
                      paper: Text(fiiData[index].papel),
                      amount: Text(fiiData[index].quantidade),
                      actualPrice: Center(child: Text(fiiData[index].valor)),
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
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        onPressed: () {
          FIIDialog().showStockDialog(context, (res) async {
            await DocManagement().saveStock(res, widget.year, widget.month);
            _loadFIIs();
          });
          fiiData.add(FIIData('a', 'b', 'c'));
          setState(() {});
        },
        child: const Text('FII Reserva'),
      ),
    );
  }

  _horizontalDivisor() {
    return Container(width: 502, height: 0.5, color: Colors.black);
  }

  _loadFIIs() {
    fiiData.clear();
    _loadingControl(true);

    fiiData.add(FIIData('IRBR3', '67', '123'));
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
