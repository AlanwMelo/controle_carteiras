import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BeautifulContainer extends StatelessWidget {
  final Color color;
  final Widget child;

  const BeautifulContainer(
      {super.key, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: Container(
        color: color,
        child: Card(
          elevation: 12,
          child: child,
        ),
      ),
    );
  }
}
