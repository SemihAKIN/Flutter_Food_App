import 'package:geolocator/geolocator.dart';

//A function to asynchronously retrieve the current location
Future<Position?> getCurrentLocation() async {
  //Check the user's location permission
  LocationPermission permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    //If location permission is denied, request permission from the user
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      //If the user still denies permission, you can display an appropriate message or take necessary actions
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    //If the user has denied location permission indefinitely, you can direct them to device settings
    return null;
  }

  //Finally, retrieve the current location and return it
  return await Geolocator.getCurrentPosition();
}
