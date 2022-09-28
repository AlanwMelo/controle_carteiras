import 'package:controle_carteiras/data/googleSignIn.dart';
import 'package:controle_carteiras/presentation/docList/docList.dart';
import 'package:controle_carteiras/presentation/mainDoc.dart';
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
  bool mainDoc = true;
  String title = 'Bem vindo Alan!';
  String lastTitle = 'Bem vindo Alan!';
  String month = 'Junho';
  String year = '2024';

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
                        ? mainDoc
                            ? const MainDoc()
                            : OpenMonth(month: month, year: year)
                        : DocList(
                            result: (result) {
                              if (result.contains('resume')) {
                                mainDoc = true;
                                title = 'Bem vindo Alan!';
                                lastTitle = title;
                              } else {
                                mainDoc = false;
                                month = result[1];
                                year = result[0];
                                title = '${result[1]} de ${result[0]}';
                                lastTitle = title;
                              }
                              setState(() {
                                screenController = 0;
                              });
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
                child: InkWell(
                  onTap: () {
                    MyGoogleSignIn().signInWithGoogle();
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle),
                        height: 150,
                        width: 150,
                        child: Image.asset('lib/data/assets/logo-google.png')),
                  ),
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
                title = lastTitle;
                screenController = 0;
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
