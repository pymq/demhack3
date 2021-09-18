import 'package:demhack3_web/Widgets/news_feed.dart';
import 'package:demhack3_web/Widgets/site_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demhack3_web/consts.dart' as Consts;

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
          width: 720,
          height: double.infinity,
          child: ListView(
            children: [
              SiteAppBar(),
              NewsFeed()
            ],
          ),
        )
    );
  }
}