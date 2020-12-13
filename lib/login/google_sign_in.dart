import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:zeus/Main/Helper/Home/home_screen.dart';
import 'package:zeus/login/start_screen.dart';
import 'package:zeus/services/components.dart';

class GoogleLoginIn {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googlSignIn = GoogleSignIn();

  void googleLogInUser(BuildContext context) async {
    try {
      final GoogleSignInAccount googleSignInAccount = await _googlSignIn
          .signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final result = await _firebaseAuth.signInWithCredential(credential)
          .whenComplete(() async {
        final users = await Firestore.instance.collection('records').getDocuments();
        int cnt = 0;

        for (var user in users.documents) {
          if (user.data['email'] == googleSignInAccount.email) {
            cnt++;
          }
        }

        if (cnt == 0) {
          Firestore.instance.collection('records').add({
            'email': googleSignInAccount.email,
            'name': googleSignInAccount.displayName,
            'id': googleSignInAccount.id,
            'photoUrl': googleSignInAccount.photoUrl,
            'needHelp': false,
            'isSharing': false,
            'alarm': false,
            'mask': false,
            'sanitizer': false
          });
        }
      });
      if (result.user != null) {
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HelperHomeScreen()));
      }
    } catch (error) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => StartScreen()));
      Components().neverSatisfied('$error', null, context);
    }
  }

  void googleLogOutUser(BuildContext context) {
    _googlSignIn.signOut();
    _firebaseAuth.signOut();
    Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => StartScreen()));
  }

  void emailSignIn(String email, String password, BuildContext context) async {
    try {
      final result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      if (result.user != null)
        Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => HelperHomeScreen()));
    } catch (error) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => StartScreen()));
      Components().neverSatisfied('$error', null, context);
    }
  }

  void emailSignUp(String email, String password, String name, BuildContext context) async {
    try {
      final result = await _firebaseAuth
          .createUserWithEmailAndPassword(
          email: email.trim(), password: password)
          .whenComplete(() {
        Firestore.instance.collection('records').add({
          'email': email,
          'name': name,
          'needHelp': false,
          'isSharing': false,
          'alarm': false,
          'mask': false,
          'sanitizer': false
        });
      });
      if (result.user != null) {
        final user = await FirebaseAuth.instance.currentUser();
        UserUpdateInfo userUpdateInfo = UserUpdateInfo();
        userUpdateInfo.displayName = name;
        user.updateProfile(userUpdateInfo);
        Navigator.pushReplacement(
            context, CupertinoPageRoute(builder: (context) => HelperHomeScreen()));
      }
    } catch (error) {
      Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => StartScreen()));
      Components().neverSatisfied('$error', null, context);
    }
  }
}
