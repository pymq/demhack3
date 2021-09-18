import 'dart:js_util';

import 'package:demhack3_web/Pages/main_page.dart';
import 'package:demhack3_web/fingerprint_loader.dart' as FingerPrint;
import 'package:flutter/material.dart';
import 'dart:js' as js;

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
        primarySwatch: Colors.blue,
        fontFamily: 'Rubik'
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();

    FingerPrint.getBrowserFingerPrint().then((value) => {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MainPage()
    );
  }
}
