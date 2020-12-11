import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:zeus/location/permission_status.dart';
import 'package:zeus/login/start_screen.dart';

class AuthService {
  handleAuth() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            return LocationPermissionStatus().handlePermission();
          } else {
            return StartScreen();
          }
        });
  }
}