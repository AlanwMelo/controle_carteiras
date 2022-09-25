import 'package:controle_carteiras/data/docManagement.dart';
import 'package:controle_carteiras/presentation/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DocListState();
}

class _DocListState extends State<DocList> {
  int screenController = 0;
  List<GridList> gridList = [];
  List<String> yearsList = [];
  List<String> monthsList = [];

  @override
  void initState() {
    yearsList = ['2021', '2022'];
    monthsList = ['Jan', 'Fev'];
    yearsList.forEach((element) {
      gridList.add(GridList(text: element));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _willPop(),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.7),
                      border: Border(
                          bottom: BorderSide(
                              width: 5,
                              color: Colors.lightBlueAccent.withOpacity(0.2)))),
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
              onTap: () => _listTapTreatment(),
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

  _listTapTreatment() {
    if (screenController == 0) {
      screenController = 1;
      gridList.clear();
      for (var element in monthsList) {
        gridList.add(GridList(text: element));
      }
      setState(() {});
    }else{
      DocManagement().createDoc();
    }
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
}

class GridList {
  final String text;
  String id;

  GridList({required this.text, this.id = ''});
}
