import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
        controller.position.animateTo(counter*1020, duration: Duration(milliseconds: 400), curve: Curves.easeIn);
      });
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                    height: 4,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: AnimatedContainer(
                              color: 0 == counter? Colors.black: Colors.grey,
                              width: 40,
                              duration: Duration(milliseconds: 500),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: AnimatedContainer(
                              color: 1 == counter? Colors.black: Colors.grey,
                              width: 40,
                              duration: Duration(milliseconds: 500),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: AnimatedContainer(
                              color: 2 == counter? Colors.black: Colors.grey,
                              width: 40,
                              duration: Duration(milliseconds: 500),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: AnimatedContainer(
                              color: 3 == counter? Colors.black: Colors.grey,
                              width: 40,
                              duration: Duration(milliseconds: 500),
                            ),
                          ),
                        )
                      ],
                    )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      controller: controller,
                      itemCount: 4,
                      itemBuilder: (context, i) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          width: 1000,
                          height: 300,
                          color: Colors.grey,
                        );
                      }),
                  )
                )
              ]
            ),
          ),
        ],
      )
    );
  }
}