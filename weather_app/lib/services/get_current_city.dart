// --------------------------------------------------------
// Future method (for fetching the current device location)
// --------------------------------------------------------

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

Future<String> getCurrentCity() async {
  try {
    // getting location permission from USER
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    // getting current location from USER
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // convert the position into place
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // extracting the _city form placemarks
    String? city = placemarks[0].locality;

    return city ?? "";
  } catch (e) {
    rethrow;
  }
}
