import 'package:demhack3_web/Widgets/big_green_box.dart';
import 'package:demhack3_web/Widgets/history.dart';
import 'package:demhack3_web/Widgets/news_feed.dart';
import 'package:demhack3_web/Widgets/second_box.dart';
import 'package:demhack3_web/Widgets/site_appbar.dart';
import 'package:demhack3_web/Widgets/table.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {

  MainPageController mainPageController;

  MainPage(this.mainPageController);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: [
                SiteAppBar(widget.mainPageController),
                SingleChildScrollView(
                    child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: SizedBox(
                            width: 1000,
                            child: ListView(
                              shrinkWrap: true,
                              children: [
                                BigGreenBox(widget.mainPageController),
                                History(widget.mainPageController),
                                SecondBox(widget.mainPageController),
                                TableWidget(widget.mainPageController),
                                NewsFeed()
                              ],
                            ),
                          ),
                        )
                    )
                )
              ],
            ),
          )
      ),
    );
  }
}

class MainPageController {
  String response = '';
  Map rawResponse = {};

  String analysis = '';
  Map rawAnalysis = {};
}