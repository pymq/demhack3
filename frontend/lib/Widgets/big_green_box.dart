import 'package:flutter/material.dart';
import 'package:demhack3_web/consts.dart' as Consts;

class BigGreenBox extends StatefulWidget{

  BigGreenBoxController controller;

  BigGreenBox(this.controller);
  @override
  State<BigGreenBox> createState() => _BigGreenBoxState();
}

class _BigGreenBoxState extends State<BigGreenBox> {

  String name = '';

  void initState() {
    super.initState();

    widget.controller.addListener(() {
      setState(() {
        name = widget.controller.name;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFFC7EDE6),
          boxShadow: [BoxShadow(
            spreadRadius: 0,
            blurRadius: 20,
            color: Color(0xFFC7EDE6)
          )]
        ),
        height: 300,
        child: Center(
          child: Text('Ваш уникальный идентификатор: \n' + name, style: Consts.logoTextStyle,),
        ),
      ),
    );
  }
}

class BigGreenBoxController extends ChangeNotifier {
  bool _isLoaded = false;
  String _name = '';

  bool get isLoaded => _isLoaded;
  String get name => _name;

  set isLoaded(bool a) {
    _isLoaded = a;
    notifyListeners();
  }

  set name(String a) {
    name = a;
    notifyListeners();
  }
}