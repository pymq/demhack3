import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
            child: Container(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Сканируем систему')
                ],
              ),
            )
        ),
      )
    );
  }

}