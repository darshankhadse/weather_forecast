import 'package:geocoding/geocoding.dart' as geocode;
import 'package:location/location.dart';

class LocationService {
  final Location location = Location();

  Future<LocationData> getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        throw Exception('Location permissions are denied');
      }
    }
    return await location.getLocation();
  }
  Future<String> getAddressFromLatLng(double lat, double long) async {
    try {
      List<geocode.Placemark> placemarks = await geocode.placemarkFromCoordinates(lat, long);

      if (placemarks.isNotEmpty) {
        geocode.Placemark place = placemarks.reversed.last;
        String areaName = place.subLocality ?? '';
        String city = place.locality ?? '';
        String address = '$areaName, $city';
        print("Your Address for ($lat, $long) is: $address");
        return address;
      } else {
        print("No placemarks found for the provided coordinates.");
        return "No Address";
      }
    } catch (e) {
      print("Error getting placemarks: $e");
      return "No Address";
    }
  }
}
