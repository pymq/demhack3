import 'package:demhack3_web/Widgets/big_green_box.dart';
import 'package:demhack3_web/Widgets/news_feed.dart';
import 'package:demhack3_web/Widgets/second_box.dart';
import 'package:demhack3_web/Widgets/site_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(
          children: [
            SiteAppBar(),
            SingleChildScrollView(
                child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: SizedBox(
                        width: 1000,
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            BigGreenBox(BigGreenBoxController()),
                            SecondBox(),
                            NewsFeed()
                          ],
                        ),
                      ),
                    )
                )
            )
          ],
        )
    );
  }
}