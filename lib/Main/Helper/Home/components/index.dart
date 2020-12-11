import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'alarm.dart';

class Index {
  double latitude, longitude;

  Future locationAlarm(BuildContext context, String docId, String email, Timer timer) async {
    try {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      final records = await Firestore.instance
          .collection('records')
          .document('$docId')
          .get();
      double initLat = records.data['latitude'];
      double initLong = records.data['longitude'];
      bool mask = records.data['mask'];
      bool sanitizer = records.data['sanitizer'];

      double distanceInMeters = await Geolocator().distanceBetween(
          initLat, initLong, position.latitude, position.longitude);
      if (distanceInMeters >= 100 && !mask && !sanitizer) AlarmIndex().showAlertDialog(context, email, docId, timer);
      else {
        records.reference.updateData({'mask': false, 'sanitizer': false});
      }
    } catch (error) {
      print(error);
    }
  }

  Future getCurrentLocationAgain(String docId) async {
    try {
      Position position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
      latitude = position.latitude;
      longitude = position.longitude;
      await Firestore.instance
          .collection('records')
          .document('$docId')
          .updateData({
        'latitude': latitude,
        'longitude': longitude,
        'needHelp': true,
      });

      return [latitude, longitude];
    } catch (e) {
      print(e);
    }
  }

  runAnimation(AnimationController _animationController) async {
    for (int i = 0; i < 3; i++) {
      await _animationController.forward();
      await _animationController.reverse();
    }
  }
}
