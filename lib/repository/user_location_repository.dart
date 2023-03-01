import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:idream/common/references.dart';

class UserLocationRepository {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();
    debugPrint(position.toString());
    GeocodingPlatform geocodingPlatform = GeocodingPlatform.instance;
    List<Placemark>? placemark;
    await geocodingPlatform
        .placemarkFromCoordinates(position.latitude, position.longitude)
        .then((value) async {
      placemark = value;
      await userRepository.saveUserDetailToLocal(
          "locationName", value[0].name!);
      await userRepository.saveUserDetailToLocal(
          "locationName", value[0].name!);
      await userRepository.saveUserDetailToLocal("street", value[0].street!);
      await userRepository.saveUserDetailToLocal(
          "isoCountryCode", value[0].isoCountryCode!);
      await userRepository.saveUserDetailToLocal("country", value[0].country!);
      await userRepository.saveUserDetailToLocal(
          "postalCode", value[0].postalCode!);
      await userRepository.saveUserDetailToLocal(
          "administrativeArea", value[0].administrativeArea!);
      await userRepository.saveUserDetailToLocal(
          "locality", value[0].locality!);
      await userRepository.saveUserDetailToLocal(
          "subLocality", value[0].subLocality!);
      await userRepository.saveUserDetailToLocal(
          "thoroughfare", value[0].thoroughfare!);
      await userRepository.saveUserDetailToLocal(
          "subThoroughfare", placemark![0].subThoroughfare!);
      debugPrint(value[0].name!);
    });

    return position;
  }
}
