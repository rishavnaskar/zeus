import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:zeus/Notification/local_notification.dart';
import 'package:zeus/services/authservice.dart';

void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    LocalNotification.initializer();
    LocalNotification.showOneTimeNotification(DateTime.now());
    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  Workmanager.registerPeriodicTask("test_work", "test_worker",
      frequency: Duration(minutes: 15));
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
