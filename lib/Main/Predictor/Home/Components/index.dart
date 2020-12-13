import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:line_icons/line_icons.dart';
import 'package:zeus/services/components.dart';

class Index {
  Material chartItem(String title, var data, BuildContext context) {
    return Material(
      color: Color(0xff520935),
      elevation: 5.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Color(0xff303030),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(LineIcons.info_circle),
              color: Colors.white,
              onPressed: () => Components().neverSatisfied(
                title,
                Container(
                  height: 300,
                  width: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Center(child: Text(data[index].toString()));
                    },
                  ),
                ),
                context,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(1.0),
                    child: FittedBox(
                      child: Text(
                        '$title',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            letterSpacing: 1.5,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Flexible(child: SizedBox(height: 40)),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Sparkline(
                      data: data,
                      lineColor: Colors.grey,
                      pointsMode: PointsMode.all,
                      pointColor: Colors.white,
                      pointSize: 8.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}