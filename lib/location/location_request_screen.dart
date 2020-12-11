import 'package:android_intent/android_intent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zeus/location/permission_status.dart';

class LocationRequestScreen extends StatefulWidget {
  @override
  _LocationRequestScreenState createState() => _LocationRequestScreenState();
}

class _LocationRequestScreenState extends State<LocationRequestScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                  child: CircleAvatar(
                    minRadius: 60.0,
                    maxRadius: 110.0,
                    backgroundImage: AssetImage('assets/location.jpg'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text('GPS turned off',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 25.0,
                          fontFamily: 'Montserrat')),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 20.0, right: 20.0),
                  child: Text(
                      'Allow Zeus to turn on your phone GPS to locate you',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 20.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xff520935),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: RaisedButton(
                  color: Colors.transparent,
                  elevation: 0.0,
                  child: Text('Turn on GPS', style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  focusColor: Colors.white,
                  onPressed: () async{
                    final AndroidIntent intent = AndroidIntent(
                      action: 'android.settings.LOCATION_SOURCE_SETTINGS',);
                    intent.launch();
                    setState(() {
                      LocationPermissionStatus().handlePermission();
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
