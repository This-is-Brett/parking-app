import 'package:geolocator/geolocator.dart';

class LocationService {

  static Future<Position> getLocation() async {

    LocationPermission permission =
        await Geolocator.requestPermission();

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

}