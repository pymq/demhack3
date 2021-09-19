import 'package:demhack3_web/Pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:demhack3_web/consts.dart' as Consts;

class BigGreenBox extends StatefulWidget{

  MainPageController controller;

  BigGreenBox(this.controller);
  @override
  State<BigGreenBox> createState() => _BigGreenBoxState();
}

class _BigGreenBoxState extends State<BigGreenBox> {

  String name = '';
  String bname = '';
  bool isH = false;

  void initState() {
    super.initState();

    name = widget.controller.rawResponse['Fingerprint']['UserIdHuman'];
    bname = widget.controller.rawResponse['Fingerprint']['UserId'];
    isH = widget.controller.rawResponse['History'].length != 0;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 50),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
              colors: [Color(0xFFC7EDE6), Color(0xFFE0F6F2)]
          ),
            boxShadow: [BoxShadow(
              blurRadius: 16,
              offset: Offset(0,4),
              color: Color(0xFFC7EDE6)
            )]
        ),
        height: 300,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.all(40),
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ваш уникальный идентификатор: \n', style: Consts.logoTextStyle,),
                  SelectableText(name, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30, color: isH? Colors.red: Colors.green),),
                  SelectableText(bname, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.grey),)
                ],
              )
            ),
            Container(
                margin: EdgeInsets.all(40),
                alignment: Alignment.bottomRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Что это значит?', style: Consts.subTextStyle,),
                )
            )
          ],
        )
      ),
    );
  }
}