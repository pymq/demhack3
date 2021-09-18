import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Map response = ModalRoute.of(context)!.settings.arguments as Map;
    String r = JsonEncoder.withIndent('  ').convert(json.decode(response['response']));

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