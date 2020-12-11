import 'package:geolocator/geolocator.dart';

class Index {
  launchURL() async {
    Position position = await Geolocator().getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    double latitude = position.latitude;
    double longitude = position.longitude;

    var url =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    return url;
  }
}
