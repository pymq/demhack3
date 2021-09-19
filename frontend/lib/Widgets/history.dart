import 'package:demhack3_web/Pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:demhack3_web/consts.dart' as Consts;

class History extends StatefulWidget {

  MainPageController controller;

  History(this.controller);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {


  List months = [
    'Январь', 'Февраль', 'Март','Апрель','Май','Июнь','Июль','Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
  ];

  List<TableRow> keys = [
    TableRow()
  ];

  void initState() {
    super.initState();

    compute(
        generateRow,
        widget.controller.rawResponse['History'] as List).then((value) {
      setState(() {
        keys = value;
      });
    });

  }


  List<TableRow> generateRow(List v1) {

    DateTime a;

    List<TableRow> t = [];
    for(int i = 0; i < (v1.length > 10? 10: v1.length); i++) {
      a = DateTime.parse(v1[i]['CreatedAt']);
      t.add(TableRow(
          children: [
            Text(a.year.toString() + ' г.'),
            Text(months[a.month-1] + ', ' + a.day.toString()),
            Text((a.hour+3).toString() +':' + (a.minute.toString().length > 1? a.minute.toString() : '0'+a.minute.toString())),
          ]
      ));
    }

    return t;
  }

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
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
          height: 330,
          child: Container(
              margin: EdgeInsets.all(40),
              alignment: Alignment.topLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Прошлые сеансы:\n', style: Consts.logoTextStyle,),
                  Table(
                    children: keys,
                  )
                ],
              )
          ),
      ),
    );
  }
}