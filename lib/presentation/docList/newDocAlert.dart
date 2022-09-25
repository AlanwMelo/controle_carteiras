import 'package:controle_carteiras/presentation/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewDocDialog {
  final List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];
  String selectedMonth = '';
  TextEditingController textEditingController = TextEditingController();

  showNewDocDialog(BuildContext context, Function(List<String>) result) {
    return showDialog(
        context: context,
        builder: (context) => StatefulBuilder(builder: (context, setState) {
              return Container(
                color: Colors.white.withOpacity(0.3),
                child: Center(
                  child: BeautifulContainer(
                    color: Colors.lightBlueAccent.withOpacity(0.5),
                    child: Container(
                      color: Colors.lightBlueAccent.withOpacity(0.2),
                      width: 300,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(top: 8),
                              child: const Text(
                                'Relatório referente a',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )),
                          Container(
                            margin: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Text(
                                  'Ano: ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                    height: 25,
                                    width: 220,
                                    child: TextFormField(
                                      controller: textEditingController,
                                      keyboardType: TextInputType.number,
                                    ))
                              ],
                            ),
                          ),
                          _monthSelection(setState),
                          _lastLine(context, result),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }));
  }

  _monthSelection(Function setState) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: 300,
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: months.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, childAspectRatio: 1.8),
        itemBuilder: (BuildContext context, int index) {
          bool containerSelected = selectedMonth == months[index];
          return InkWell(
            onTap: () {
              selectedMonth = months[index];
              setState(() {});
            },
            child: Container(
                margin: const EdgeInsets.all(2),
                child: BeautifulContainer(
                    color: containerSelected
                        ? Colors.green.withOpacity(0.7)
                        : Colors.blueGrey.withOpacity(0.7),
                    child: Container(
                      color: containerSelected
                          ? Colors.green.withOpacity(0.7)
                          : Colors.white.withOpacity(0.7),
                      child: Center(
                          child: Text(
                        months[index].substring(0, 3),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                    ))),
          );
        },
      ),
    );
  }

  _lastLine(BuildContext context, Function result) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.red,
                child: const Center(
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                result([textEditingController.text, selectedMonth]);
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.green,
                child: const Center(
                  child: Text(
                    'Criar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
