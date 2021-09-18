import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demhack3_web/consts.dart' as Consts;

class SiteAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  height: 40,
                  width: 145,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () {},
                      child: SvgPicture.asset('assets/fButton.svg', fit: BoxFit.fitHeight,),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(right: 50),
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
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