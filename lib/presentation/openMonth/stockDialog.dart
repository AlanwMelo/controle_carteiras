import 'package:controle_carteiras/presentation/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StockDialog {
  showStockDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
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
                            'Papel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          )),
                      Container(
                        margin: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Text(
                              'Papel: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: SizedBox(
                                  height: 25,
                                  child: TextFormField(
                                      //controller: textEditingController,
                                      )),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Text(
                              'Qtd.: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: SizedBox(
                                  height: 25,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    //controller: textEditingController,
                                  )),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Text(
                              'Compra: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: SizedBox(
                                  height: 25,
                                  child: TextFormField(
                                    //controller: textEditingController,
                                    keyboardType: TextInputType.number,
                                  )),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Text(
                              'Venda: ',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: SizedBox(
                                  height: 25,
                                  child: TextFormField(
                                    //controller: textEditingController,
                                    keyboardType: TextInputType.number,
                                  )),
                            )
                          ],
                        ),
                      ),
                      _lastLine(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  _lastLine(BuildContext context) {
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
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.green,
                child: const Center(
                  child: Text(
                    'Confirmar',
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
