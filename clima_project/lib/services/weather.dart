import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:clima_project/services/location.dart';
import 'package:clima_project/secrets.dart';

// from secrets.dart
const apiKey = openWeatherApiKey;

// WeatherAPI base URL
const weatherApiBaseUrl = 'https://api.weatherapi.com/v1';

class WeatherModel {
  Future<Map<String, dynamic>> getCityWeather(String cityName) async {
    final uri = Uri.parse(
      '$weatherApiBaseUrl/current.json?key=$apiKey&q=$cityName&aqi=no',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getLocationWeather() async {
    final location = Location();
    await location.getCurrentLocation();

    if (location.latitude == null || location.longitude == null) {
      throw Exception('Location not available');
    }

    final query = '${location.latitude},${location.longitude}';
    final uri = Uri.parse(
      '$weatherApiBaseUrl/current.json?key=$apiKey&q=$query&aqi=no',
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Failed to load weather data: ${response.statusCode}');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  String getWeatherIcon(String conditionText) {
    final text = conditionText.toLowerCase();

    if (text.contains('thunder')) return '⛈';
    if (text.contains('rain') || text.contains('drizzle')) return '🌧';
    if (text.contains('snow') || text.contains('sleet')) return '❄️';
    if (text.contains('fog') || text.contains('mist')) return '🌫';
    if (text.contains('cloud')) return '☁️';
    if (text.contains('sunny') || text.contains('clear')) return '☀️';

    return '🤷‍♂️';
  }

  String getMessage(double tempC) {
    if (tempC > 25) return 'It’s 🍦 time';
    if (tempC > 20) return 'Time for shorts and 👕';
    if (tempC < 10) return 'You’ll need 🧣 and 🧤';
    return 'Bring a 🧥 just in case';
  }
}
