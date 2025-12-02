import 'package:flutter/material.dart';
import 'package:clima_project/services/weather.dart';
import 'package:clima_project/screens/location_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    getLocationData();
  }

Future<void> getLocationData() async {
  print('getLocationData: start');
  try {
    // 👇 STATIC CITY HERE – change "Athens" to whatever you like
    var weatherData = await WeatherModel().getCityWeather('Athens');
    print('getLocationData: got weather data');

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LocationScreen(locationWeather: weatherData),
      ),
    );
  } catch (e, st) {
    print('getLocationData: ERROR $e');
    print(st);
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LocationScreen(locationWeather: null),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
