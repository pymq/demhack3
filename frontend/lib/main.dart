import 'package:demhack3_web/Pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:demhack3_web/fingerprint_loader.dart' as FingerPrint;

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
  
  void initState() {
    super.initState();
    FingerPrint.getBrowserFingerPrint().then((value) => print(FingerPrint.stringify(value)));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MainPage()
    );
  }
}