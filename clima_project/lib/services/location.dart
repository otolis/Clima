import 'dart:async';
import 'package:geolocator/geolocator.dart';

class Location {
  double? latitude;
  double? longitude;

  Future<void> getCurrentLocation() async {
    print('[Location] getCurrentLocation: start');
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      print('[Location] serviceEnabled = $serviceEnabled');
      if (!serviceEnabled) {
        print('[Location] Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      print('[Location] initial permission = $permission');

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        print('[Location] permission after request = $permission');
        if (permission == LocationPermission.denied) {
          print('[Location] Permission denied by user.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('[Location] Permission permanently denied.');
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 10),
      );

      latitude = position.latitude;
      longitude = position.longitude;
      print('[Location] got position: $latitude, $longitude');
    } on TimeoutException catch (e) {
      print('[Location] TIMEOUT while getting location: $e');
    } catch (e) {
      print('[Location] ERROR while getting location: $e');
    }
  }
}
