import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:clima_project/services/location.dart';
import 'package:clima_project/secrets.dart';

// from secrets.dart
const String apiKey = openWeatherApiKey;

// Make sure `url` in secrets.dart is: 'https://api.weatherapi.com/v1'
const String weatherApiBaseUrl = url;

class WeatherModel {
  Future<Map<String, dynamic>> getCityWeather(String cityName) async {
    final uri = Uri.parse(
      '$weatherApiBaseUrl/current.json?key=$apiKey&q=$cityName&aqi=no',
    );
    print('[WeatherModel] getCityWeather → $uri');

    http.Response response;
    try {
      response = await http.get(uri);
      print('[WeatherModel] getCityWeather status: ${response.statusCode}');
    } catch (e) {
      print('[WeatherModel] getCityWeather HTTP error: $e');
      rethrow;
    }

    if (response.statusCode != 200) {
      print('[WeatherModel] getCityWeather body: ${response.body}');
      throw Exception(
        'Failed to load weather data: ${response.statusCode}',
      );
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getLocationWeather() async {
    print('[WeatherModel] getLocationWeather: start');

    final location = Location();
    await location.getCurrentLocation();

    print('[WeatherModel] location after getCurrentLocation: '
        'lat=${location.latitude}, lon=${location.longitude}');

    final lat = location.latitude;
    final lon = location.longitude;

    if (lat == null || lon == null) {
      throw Exception('Location not available (latitude/longitude are null)');
    }

    final query = '$lat,$lon';
    final uri = Uri.parse(
      '$weatherApiBaseUrl/current.json?key=$apiKey&q=$query&aqi=no',
    );
    print('[WeatherModel] getLocationWeather → $uri');

    http.Response response;
    try {
      response = await http.get(uri);
      print('[WeatherModel] getLocationWeather status: ${response.statusCode}');
    } catch (e) {
      print('[WeatherModel] getLocationWeather HTTP error: $e');
      rethrow;
    }

    if (response.statusCode != 200) {
      print('[WeatherModel] getLocationWeather body: ${response.body}');
      throw Exception(
        'Failed to load weather data: ${response.statusCode}',
      );
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
