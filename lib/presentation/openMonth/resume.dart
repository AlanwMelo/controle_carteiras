import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Resume extends StatefulWidget {
  const Resume({super.key});

  @override
  State<StatefulWidget> createState() => _ResumeState();
}

class _ResumeState extends State<Resume> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _resumeContainer(),
          _resumeContainer(),
          _resumeContainer(),
          _resumeContainer(),
        ],
      ),
    );
  }

  _resumeContainer() {
    Widget sizedBox = const SizedBox(height: 6);
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.lightBlueAccent.withOpacity(0.8),
              offset: Offset(0.0, 1.0), //(x,y)
              blurRadius: 4.0,
            ),
          ],
        ),
        width: 250,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 4, top: 4),
                    child: Text(
                      'Valor a ser reinvestido',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
            sizedBox,
            Text(
              'R\$ 1000000',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            sizedBox,
            Text(
              '25% do retorno',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
