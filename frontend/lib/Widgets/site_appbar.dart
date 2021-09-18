import 'dart:convert';

import 'package:demhack3_web/Pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demhack3_web/consts.dart' as Consts;

class SiteAppBar extends StatefulWidget {
  MainPageController mainPageController;

  SiteAppBar(this.mainPageController);
  @override
  State<SiteAppBar> createState() => _SiteAppBarState();
}

class _SiteAppBarState extends State<SiteAppBar> {


  void openDialog() async {
    Navigator.pushNamed(context, '/DebugPage', arguments: {'response': widget.mainPageController.response});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: 70,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset('assets/icon.svg', height: 70),
                Text('BFP', style: Consts.logoTextStyle)
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 60,
                  width: 210,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: openDialog,
                      child: SvgPicture.asset('assets/fButton.svg', fit: BoxFit.fitHeight,),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 50),
                  height: 60,
                  width: 60,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: SvgPicture.asset('assets/sButton.svg', fit: BoxFit.fitHeight,),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}