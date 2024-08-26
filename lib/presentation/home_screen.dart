import 'package:flutter/material.dart';

import '../api/weather_service.dart';
import '../utils/location.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var isLoading = true;
  final WeatherService weatherService = WeatherService();
  final LocationService locationService = LocationService();
  Map<String, dynamic>? weatherData;
  String? errorMessage;
  String? address;

  @override
  void initState() {
    super.initState();
    fetchWeatherForCurrentLocation();
  }

  Future<void> fetchWeatherForCurrentLocation() async {
    try {
      final locationData = await locationService.getLocation();
      double lat = locationData.latitude!;
      double lng = locationData.longitude!;
      weatherData = await weatherService.fetchWeatherByLocation(
          locationData.latitude!, locationData.longitude!);
      address = await locationService.getAddressFromLatLng(lat, lng);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: const Text('Weather Forecast')),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : weatherData != null
                ? weatherContent()
                : Center(
                    child: Text(errorMessage ?? 'Failed to load weather data'),
                  ),
      ),
    );
  }

  Widget weatherContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Current Weather in $address',
            style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          Text('Temperature: ${weatherData!['main']['temp']}°C'),
          Text('Condition: ${weatherData!['weather'][0]['description']}'),
          Text('Humidity: ${weatherData!['main']['humidity']}%'),
          Text('Wind Speed: ${weatherData!['wind']['speed']} m/s'),
        ],
      ),
    );
  }
}
