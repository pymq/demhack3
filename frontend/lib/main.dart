import 'package:demhack3_web/Pages/debug_page.dart';
import 'package:demhack3_web/Pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:demhack3_web/fingerprint_loader.dart' as FingerPrint;
import 'package:demhack3_web/server.dart' as Server;

import 'Pages/main_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Rubik'
      ),
      routes: {
        "/DebugPage":(BuildContext context) => DebugPage(),
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  MainPageController mainPageController = MainPageController();
  
  void initState() {
    super.initState();
    FingerPrint.getBrowserFingerPrint().then((value) {
      var s = FingerPrint.stringify(value);
      Server.send(s).then((v) {
        mainPageController.response = v.body;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MainPage(mainPageController),
    );
  }
}
