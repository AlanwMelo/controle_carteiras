import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OpenMonth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _OpenMonthState();
}

class _OpenMonthState extends State<OpenMonth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.yellowAccent,
          child: Column(
            children: [Container(height: 220, color: Colors.green, child: Row())],
          ),
        ),
      ),
    );
  }
}
