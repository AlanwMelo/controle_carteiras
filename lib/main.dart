import 'package:controle_carteiras/data/googleSignIn.dart';
import 'package:controle_carteiras/presentation/docList/docList.dart';
import 'package:controle_carteiras/presentation/openMonth/openMonth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  int screenController = 0;
  String title = 'Bem vindo Alan!';

  @override
  void initState() {
    FirebaseAuth.instance.userChanges().listen((event) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
        ? Scaffold(
            backgroundColor: Colors.blueAccent.withOpacity(0.2),
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.blue.withOpacity(0.7),
              title: Text(title),
            ),
            body: Column(
              children: [
                Expanded(
                    child: screenController == 0
                        ? const OpenMonth()
                        : DocList(
                            result: (result) {
                              print(result);
                              screenController = 0;
                              setState(() {});
                            },
                          )),
                _bottomBar(),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: Colors.blueAccent.withOpacity(0.2),
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.blue.withOpacity(0.7),
            ),
            body: Container(
              color: Colors.blue.withOpacity(0.7),
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    MyGoogleSignIn().signInWithGoogle();
                  },
                  child: SizedBox(
                      height: 250,
                      width: 250,
                      child: Image.network(
                          'https://img2.gratispng.com/20180326/gte/kisspng-google-logo-g-suite-google-guava-google-plus-5ab8b5b15fd9f4.0166567715220545773927.jpg')),
                ),
              ),
            ),
          );
  }

  _bottomBar() {
    return Container(
      height: 50,
      color: Colors.blue.withOpacity(0.7),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: InkWell(
              onTap: () {
                screenController = 0;
                title = 'Relatório Setembro 2022';
                setState(() {});
              },
              child: const Icon(Icons.auto_graph_rounded, color: Colors.white),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                screenController = 1;
                title = 'Lista de relatórios';
                setState(() {});
              },
              child: const Icon(
                Icons.account_tree_outlined,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
              child: InkWell(
                  onTap: () => FirebaseAuth.instance.signOut(),
                  child: const Icon(Icons.login_rounded, color: Colors.white))),
        ],
      ),
    );
  }
}
