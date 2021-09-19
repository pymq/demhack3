import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NewsFeed extends StatefulWidget {
  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  
  int counter = 0;
  Timer? timer;

  ScrollController controller = ScrollController();
  
  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 5),(f) {
      setState(() {
        if (counter == 3) {
          counter = 0;
        } else {
          counter++;
        }
        controller.position.animateTo(counter*720, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 560,
      child: Column(
        children: [
          SizedBox(
            height: 4,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              itemBuilder: (context, i) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      color: i == counter? Colors.black: Colors.grey,
                      width: 40,
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 20),
                    child: SizedBox(
                      height: 460,
                      width: double.infinity,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          controller: controller,
                          itemCount: 4,
                          itemBuilder: (context, i) {
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: 700,
                              color: Colors.white,
                              child: Image.asset('assets/news.png'),
                            );
                          }),
                    )
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Container(
                        height: 460,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(32),
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [Color(0xFFEDD8BB), Color(0xFFF6EAD9)]
                            ),
                        ),
                      )
                    ],
                  )
              ),
            ],
          ),

        ],
      ),
    );
  }
}