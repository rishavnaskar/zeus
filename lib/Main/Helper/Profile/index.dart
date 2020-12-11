import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';

class Index {
  getLocation(double lat, double long) async {
    String address;
    if (lat != null && long != null) {
      final coordinates = Coordinates(lat, long);
      var result =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      address = result.first.addressLine;
    }
    return address;
  }
}
