import 'package:demhack3_web/Pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import 'package:demhack3_web/consts.dart' as Consts;

class SecondBox extends StatefulWidget{

  MainPageController mainPageController;

  SecondBox(this.mainPageController);

  @override
  State<SecondBox> createState() => _SecondBoxState();
}

class _SecondBoxState extends State<SecondBox> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 40),
      child: SizedBox(
        height: 500,
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFC3E5F7), Color(0xFFDEF1FB)]
                  ),
                boxShadow: [BoxShadow(
                  blurRadius: 41.16,
                  offset: Offset(0, 12.35),
                  color: Color(0xF0B225A)
                )]
                ),

                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      child: SvgPicture.asset('assets/pc_icon.svg', width: 160,),
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/memory_icon.svg'),
                      title: Text(widget.mainPageController.rawAnalysis['deviceMemory'].toString() + ' Гб'),
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/screen_icon.svg'),
                      title: Text(widget.mainPageController.rawAnalysis['screenResolution'][0].toString() + 'х' + widget.mainPageController.rawAnalysis['screenResolution'][1].toString() ),
                    ),
                    ListTile(
                      leading: SvgPicture.asset('assets/videocard_icon.svg'),
                      title: Text('агде...'),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFCAAFED), Color(0xFFE2D3F6)]
                  ),
                  boxShadow: [BoxShadow(
                    blurRadius: 41.16,
                    offset: Offset(0, 12.35),
                    color: Color(0xF0B225A)
                  )]
                ),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      height: 300,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: MapboxMap(
                          accessToken: Consts.map_access_token,
                          styleString: Consts.map_styleString,
                          initialCameraPosition: CameraPosition(
                            zoom: 11.0,
                            target: LatLng(
                                double.parse(widget.mainPageController.rawResponse['Fingerprint']['Metrics']['Location']['lat'].toString()),
                                double.parse(widget.mainPageController.rawResponse['Fingerprint']['Metrics']['Location']['long'].toString())
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}