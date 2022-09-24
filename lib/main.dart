import 'package:controle_carteiras/presentation/openMonth/openMonth.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Bem vindo Alan!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.withOpacity(0.2),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue.withOpacity(0.7),
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          const Expanded(child: OpenMonth()),
          Container(
            height: 50,
            color: Colors.blue.withOpacity(0.7),
          ),
        ],
      ),
    );
  }
}
