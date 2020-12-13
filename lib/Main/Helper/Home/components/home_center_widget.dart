import 'package:flutter/material.dart';
import 'package:zeus/Main/Helper/Requests/request_screen.dart';
import 'package:zeus/Main/Helper/Response/response_screen.dart';

class HomeCenterWidgets extends StatelessWidget {
  HomeCenterWidgets({this.headerText, this.iconData, this.email, this.docId});

  final String headerText;
  final IconData iconData;
  final String email;
  final String docId;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4.5,
      width: MediaQuery.of(context).size.width / 2.5,
      child: RaisedButton(
        color: Colors.white,
        elevation: 5.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        onPressed: () {
          if (headerText == 'Requests')
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) =>
                        RequestScreen(email: email, docId: docId)));
          else if (headerText == 'Responses')
            Navigator.push(
                context,
                PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 400),
                    pageBuilder: (_, __, ___) =>
                        ResponseScreen(email: email, docId: docId)));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: SizedBox(height: 20.0)),
            Icon(iconData, color: Color(0xff520935), size: 40.0),
            Expanded(child: SizedBox(height: 20.0)),
            Text(headerText,
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xff520935))),
            Expanded(child: SizedBox(height: 20.0)),
          ],
        ),
      ),
    );
  }
}
