# Clima

A simple Flutter weather app that shows the current temperature and a short text message, using a free weather API.

The app is based on the London App Brewery “Clima” project, but updated to use WeatherAPI and modern Flutter.

---

## Features

- Get weather for the current device location (GPS)
- Search weather by city name
- Show current temperature in Celsius
- Show a short message based on how warm or cold it is
- Works on Android emulator or physical device (and iOS if configured)

---

## Tech Stack

- Flutter / Dart
- `http` – REST API calls
- `geolocator` – device location
- WeatherAPI – weather data provider

---
## Getting Started

Clone the repository:

```bash
git clone https://github.com/otolis/Clima.git
cd Clima/clima_project
```

Install dependencies:

```bash
flutter pub get
```

Run the app:

```bash
flutter run
```

If you are using the Android emulator, open the Location panel in the emulator controls and set a test GPS location so the “near me” button has coordinates to work with.

---

## Project Structure

High-level structure of the Flutter project:

```text
clima_project/
  lib/
    main.dart                 # App entry point
    screens/
      loading_screen.dart     # Splash/loading – fetches initial weather
      location_screen.dart    # Main UI with temperature and message
      city_screen.dart        # Lets the user type a city name
    services/
      weather.dart            # WeatherAPI integration
      location.dart           # Geolocator wrapper
    utilities/
      constants.dart          # Text styles and shared UI constants
    secrets.dart              # Your API key and base URL (local only)
```

---

## How It Works

- `loading_screen.dart` fetches the initial weather (either for a static city or using GPS).
- The result is passed into `LocationScreen`, which:
  - Parses the WeatherAPI JSON response.
  - Displays the temperature, text icon and message.
- The “near me” button calls `WeatherModel.getLocationWeather()`, which:
  - Uses the `Location` service to obtain latitude and longitude.
  - Calls WeatherAPI with those coordinates.
- The city button pushes `CityScreen`, where the user can enter a city name and request weather for that city.

---

## Possible Improvements

- Add a multi-day forecast screen.
- Use WeatherAPI’s condition icons instead of text-based icons.
- Support light and dark themes.
- Store the last selected city locally so it is restored on app start.

---

## License

This is a learning project. You can clone it and use it as a starting point for your own experiments or training.