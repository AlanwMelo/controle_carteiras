import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_carteiras/data/docManagement.dart';
import 'package:controle_carteiras/data/monthsList.dart';
import 'package:controle_carteiras/presentation/container.dart';
import 'package:controle_carteiras/presentation/docList/newDocAlert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocList extends StatefulWidget {
  const DocList({super.key, required this.result});

  final Function(List<String>) result;

  @override
  State<StatefulWidget> createState() => _DocListState();
}

class _DocListState extends State<DocList> {
  int screenController = 0;
  bool loading = false;
  List<GridList> gridList = [];
  List<String> yearsList = [];
  List<String> months = [];

  @override
  void initState() {
    _loadYearsList();
    yearsList.forEach((element) {
      gridList.add(GridList(text: element));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPop(),
      child: Stack(
        children: [
          loading
              ? Container(
                  color: Colors.white.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : Container(),
          Scaffold(
            backgroundColor: Colors.black.withOpacity(0),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    onTap: () => _newDoc(),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.7),
                          border: Border(
                              bottom: BorderSide(
                                  width: 5,
                                  color: Colors.lightBlueAccent
                                      .withOpacity(0.2)))),
                      child: const Center(
                          child: Text(
                        'Adcionar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                  _lists(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _lists() {
    return SizedBox(
      height: 800,
      child: GridView.builder(
          itemCount: gridList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
          ),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () => _listTapTreatment(gridList[index].text),
              child: Container(
                margin: const EdgeInsets.all(12),
                child: BeautifulContainer(
                    color: Colors.lightBlueAccent.withOpacity(0.5),
                    child: Container(
                        color: Colors.lightBlueAccent.withOpacity(0.2),
                        child: Center(
                            child: Text(
                          gridList[index].text,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        )))),
              ),
            );
          }),
    );
  }

  _listTapTreatment(String year) async {
    if (screenController == 0) {
      _loadController(true);
      gridList.clear();

      screenController = 1;
      QuerySnapshot result = await DocManagement().getMonths(year);

      months = await _sortMonths(result.docs);
      for (var element in months) {
        gridList.add(GridList(text: element));
      }

      _loadController(false);
    } else {
      //DocManagement().createDoc();
    }
  }

  _loadYearsList() async {
    _loadController(true);
    QuerySnapshot result = await DocManagement().getDocuments();
    for (var element in result.docs) {
      yearsList.add(element.id);
      gridList.add(GridList(text: element.id));
    }
    _loadController(false);
  }

  Future<bool> _willPop() async {
    if (screenController == 1) {
      screenController = 0;
      gridList.clear();
      for (var element in yearsList) {
        gridList.add(GridList(text: element));
      }
      setState(() {});
      return false;
    } else {
      print('nop');
      return false;
    }
  }

  _loadController(bool bool) {
    loading = bool;
    setState(() {});
  }

  _newDoc() {
    return NewDocDialog().showNewDocDialog(context, (result) async {
      _loadController(true);
      await DocManagement().createDoc(year: result[0], month: result[1]);
      _loadController(false);
      widget.result(result);
    });
  }

  _sortMonths(List<QueryDocumentSnapshot<Object?>> docs) async {
    List monthsToRemove = [
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

    List<String> monthsResult = [
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

    for (var doc in docs) {
      if (monthsToRemove.contains(doc.id)) {
        monthsToRemove.removeWhere((element) => element == doc.id);
      }
    }

    for (var month in monthsToRemove) {
      monthsResult.removeWhere((element) => month == element);
    }
    return monthsResult;
  }
}

class GridList {
  final String text;
  String id;

  GridList({required this.text, this.id = ''});
}
