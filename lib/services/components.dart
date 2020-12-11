import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Components {
  Future<void> neverSatisfied(
      String header, Widget body, BuildContext context) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            title: Row(
              children: [
                Text(header, style: TextStyle(fontFamily: 'Montserrat')),
                Spacer(),
                SizedBox(
                  height: 20.0,
                  width: 20.0,
                  child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      backgroundColor: Color(0xff520935)),
                ),
              ],
            ),
            content: body,
          );
        });
  }

  snackBarFunction(String text) {
    return SnackBar(
      duration: Duration(seconds: 1),
      content: Container(
        padding: EdgeInsets.zero,
        child: Text(text,
            textAlign: TextAlign.center, style: TextStyle(letterSpacing: 2.0)),
      ),
      elevation: 15.0,
      backgroundColor: Colors.black,
      behavior: SnackBarBehavior.floating,
    );
  }
}
