import 'package:flutter/material.dart';
import 'package:zeus/services/authservice.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff520935),
        accentColor: Colors.white,
        unselectedWidgetColor: Color(0xff520935),
        cursorColor: Color(0xff520935),
        cardColor: Colors.grey,
        buttonColor: Color(0xff520935),
      ),
      debugShowCheckedModeBanner: false,
      home: AuthService().handleAuth(),
    );
  }
}
