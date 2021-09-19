import 'package:demhack3_web/Pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TableWidget extends StatefulWidget {

  MainPageController mainPageController;

  TableWidget(this.mainPageController);

  @override
  State<TableWidget> createState() => _TableWidgetState();
}

class _TableWidgetState extends State<TableWidget> {

  List<TableRow> keys = [
    TableRow()
  ];

  List<TableRow> generateRow(Map v1) {
    List<TableRow> t = [];
    for(int i = 0; i < v1.length; i++) {
      if (v1.keys.elementAt(i) != 'canvas' && v1.values.elementAt(i) != null) {
        t.add(TableRow(
            children: [
              SelectableText(v1.keys.elementAt(i).toString()),
              SelectableText(v1.values.elementAt(i).toString()),
            ]
        ));
      }
    }

    return t;
  }

  void initState() {
    super.initState();

    compute(
        generateRow,
        widget.mainPageController.rawResponse['Fingerprint']['Metrics'] as Map).then((value) {
      setState(() {
        keys = value;
      });
    });
  }

  bool isActivated = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          height: isActivated? 1000:200,
            duration: Duration(milliseconds: 400),
            child: Stack(
              children: [
                Container(
                  height: double.infinity,
                  child: SingleChildScrollView(
                    child: Table(
                      children: keys,
                    ),
                    physics: NeverScrollableScrollPhysics(),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 400),
                    height: 100,
                    width: double.infinity,
                    decoration: isActivated? const BoxDecoration() : const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [Color(0xFFFFFFFF), Color(0x70FFFFFF)]
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        TextButton(
            onPressed: () {
              setState(
                () {
                  isActivated = !isActivated;
                }
              );
            },
            child: Text('Открой'))
      ],
    );
  }
}