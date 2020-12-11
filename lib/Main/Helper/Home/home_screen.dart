import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zeus/Main/Helper/Profile/profile_screen.dart';
import 'package:zeus/login/google_sign_in.dart';
import 'package:zeus/login/start_screen.dart';
import 'package:zeus/services/components.dart';
import 'components/alarm.dart';
import 'components/home_center_widget.dart';
import 'components/index.dart';

String photoUrl;

class HomeScreen extends StatefulWidget {
  HomeScreen({this.name});

  final String name;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false, needHelp, alarm;
  String email, name, docId, googleId, phoneNumber;
  double latitude, longitude;
  AnimationController animationController;
  Animation<double> animation;
  QuerySnapshot userRecords;

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) {
            return IconButton(
                icon: Icon(Icons.edit_location),
                color: Colors.black,
                onPressed: () {
                  getCurrentLocationAgain();
                  Scaffold.of(context).showSnackBar(
                      Components().snackBarFunction('Updating location'));
                });
          },
        ),
        actions: <Widget>[
          AlarmButton(email: email, docId: docId, alarm: alarm),
          IconButton(
            icon: Icon(Icons.person_outline),
            color: Colors.black,
            onPressed: () => Navigator.push(
                context,
                CupertinoPageRoute(
                    builder: (context) => ProfileScreen(email: email))),
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(child: SizedBox(height: 30.0)),
                Text(
                    name != null
                        ? name
                        : (widget.name != null ? widget.name : ''),
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                      fontSize: 18.0,
                    )),
                Text(email != null ? email : '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      letterSpacing: 2.0,
                    )),
                Flexible(child: SizedBox(height: 30.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'request',
                      flightShuttleBuilder: _flightShuttleBuilder,
                      child: HomeCenterWidgets(
                          email: email,
                          headerText: 'Requests',
                          docId: docId,
                          iconData: Icons.notification_important),
                    ),
                    Flexible(child: SizedBox(width: 60.0)),
                    Hero(
                      tag: 'response',
                      flightShuttleBuilder: _flightShuttleBuilder,
                      child: HomeCenterWidgets(
                          email: email,
                          headerText: 'Responses',
                          docId: docId,
                          iconData: Icons.chat),
                    ),
                  ],
                ),
                Flexible(child: SizedBox(height: 60.0)),
                Text('Do you need help?',
                    style: TextStyle(
                        color: Color(0xff520935),
                        fontFamily: 'Montserrat',
                        fontSize: 23.0)),
                Flexible(child: SizedBox(height: 40.0)),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3,
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0)),
                      elevation: 10.0,
                      color: Colors.white,
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            needHelp = !needHelp;
                            if (needHelp == true) {
                              getCurrentLocationAgain();
                            } else {
                              Firestore.instance
                                  .collection('records')
                                  .document('$email')
                                  .updateData({'needHelp': false});
                            }
                          });
                        }
                      },
                      child: Column(
                        children: [
                          Expanded(child: SizedBox(height: 40.0)),
                          Text('Broadcasting',
                              style: TextStyle(
                                  color: Color(0xff520935),
                                  fontFamily: 'Montserrat',
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0)),
                          Expanded(flex: 2, child: SizedBox(height: 40.0)),
                          Transform.scale(
                            scale: needHelp != true ? 2.0 : animation.value,
                            child: needHelp != null
                                ? Builder(
                                    builder: (context) {
                                      return Checkbox(
                                        value: needHelp,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.padded,
                                        checkColor: Color(0xff520935),
                                        onChanged: (value) {
                                          setState(() {
                                            needHelp = !needHelp;
                                            if (needHelp == true) {
                                              getCurrentLocationAgain();
                                              Scaffold.of(context).showSnackBar(
                                                  Components().snackBarFunction(
                                                      'Updating location'));
                                            } else {
                                              Firestore.instance
                                                  .collection('records')
                                                  .document('$docId')
                                                  .updateData(
                                                      {'needHelp': false});
                                            }
                                          });
                                        },
                                      );
                                    },
                                  )
                                : CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                    backgroundColor: Color(0xff520935)),
                          ),
                          Expanded(flex: 2, child: SizedBox(height: 40.0)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1)
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 25,
            right: 10.0,
            child: IconButton(
              icon: Icon(Icons.exit_to_app),
              color: Colors.black,
              onPressed: () {
                setState(() {
                  pageId = null;
                  photoUrl = null;
                });
                if (googleId == null) {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) => StartScreen()));
                } else {
                  GoogleLoginIn().googleLogOutUser(context);
                }
                PaintingBinding.instance.imageCache.clear();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    animation = Tween<double>(begin: 1, end: 3).animate(animationController)
      ..addListener(() {
        if (mounted) {
          setState(() {});
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void getCurrentUser() async {
    try {
      final user = await FirebaseAuth.instance.currentUser();
      if (user != null) {
        if (mounted) {
          setState(() {
            email = user.email;
            name = user.displayName;
            if (user.photoUrl != null) photoUrl = user.photoUrl;
            if (user.phoneNumber != null) phoneNumber = user.phoneNumber;
          });
        }
        userRecords = await Firestore.instance
            .collection('records')
            .where('email', isEqualTo: email)
            .getDocuments();
        if (mounted) {
          setState(() {
            for (var record in userRecords.documents) {
              if (record.data['needHelp'] != null) {
                needHelp = record.data['needHelp'];
                docId = record.documentID;
                googleId = record.data['id'];
                alarm = record.data['alarm'];
              }
            }
            if (alarm)
              Timer.periodic(
                  Duration(minutes: 30),
                  (timer) =>
                      Index().locationAlarm(context, docId, email, timer));
          });
        }
      }
    } catch (e) {
      print(e);
    }
  }

  Future getCurrentLocationAgain() async {
    await Index()
        .getCurrentLocationAgain(docId)
        .then((data) => data.forEach((singleData) {
              if (mounted) {
                setState(() {
                  data.indexOf(singleData) == 0
                      ? latitude = singleData
                      : longitude = singleData;
                });
              }
            }));
  }
}
