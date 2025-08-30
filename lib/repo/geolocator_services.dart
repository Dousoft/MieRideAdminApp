// import 'package:geolocator/geolocator.dart';
//
// class GeoLocatorServices{
//
//   static Future<Position?> getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//
//       if (permission == LocationPermission.denied) {
//         print('Location permissions are denied.');
//         return null;
//       }
//
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//
//       print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
//       return position;
//     } catch (e) {
//       print("Error: $e");
//       return null;
//     }
//   }
//
// }