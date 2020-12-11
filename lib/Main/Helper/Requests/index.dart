import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class Index {
  double latitude, longitude;
  List<String> names = [];
  List<String> emails = [];
  List<String> requestAccepted = [];

  getData(String email) async {
    final records =
    await Firestore.instance.collection('records').getDocuments();
    for (var record in records.documents) {
      if (record.data['email'] == email) {
        latitude = record.data['latitude'];
        longitude = record.data['longitude'];

        if (record.data['requestAccepted'] != null) {
          for (int i = 0; i < record.data['requestAccepted'].length; i++) {
            if (!requestAccepted.contains(record.data['requestAccepted']))
              requestAccepted.add(record.data['requestAccepted'][i].toString());
          }
        }
      }
    }

    for (var record in records.documents) {
      if (record.data['email'] != email && record.data['needHelp'] == true) {
        double distanceInMeters = await Geolocator().distanceBetween(latitude,
            longitude, record.data['latitude'], record.data['longitude']);
        if (distanceInMeters < 20000.0) {
          if (!emails.contains(record.data['email'])) {
            emails.add(record.data['email']);
            names.add(record.data['name']);
          }
        }
      }
    }
    return [emails, names, requestAccepted];
  }
}
