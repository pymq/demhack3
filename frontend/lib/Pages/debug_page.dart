import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class DebugPage extends StatefulWidget {

  @override
  State<DebugPage> createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  Future<String> computableJSON(String r) async {
    return JsonEncoder.withIndent('  ').convert(
        json.decode(r));
  }

  String r = '';

  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final Map response = ModalRoute
          .of(context)!
          .settings
          .arguments as Map;

      compute(computableJSON, response['response'] as String).then((value) {
        setState(() {
          r = value;
        });
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug'),
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(20),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Center(
              child: SelectableText(r),
            ),
          )
      ),
    );
  }
}