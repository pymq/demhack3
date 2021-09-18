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
                    height: 5,
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
                              width: 20,
                            ),
                          ),
                        );
                      },
                    )
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    height: 300,
                    color: Colors.grey,
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