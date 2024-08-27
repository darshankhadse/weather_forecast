import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../api/weather_service.dart';
import '../utils/location.dart';
import 'search_screen.dart';

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
        appBar: AppBar(
          title: const Text('Weather Forecast'),
          actions: [
            IconButton(
                onPressed: () async{
                  final selectedCity = await Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                        const SearchScreen()),
                  );
                  if (selectedCity != null) {
                    weatherData = await weatherService.fetchWeatherByCity(
                        selectedCity);
                    setState(() {
                      address = weatherData!['name'];
                    });
                  }
                },
                icon: const Icon(Icons.search))
          ],
        ),
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
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            //mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LottieBuilder.asset(getWeatherAnimation(
                  '${weatherData!['weather'][0]['main']}')),
              const SizedBox(height: 40.0),
              Text(
                'Current Weather in $address',
                style: const TextStyle(
                    fontSize: 22.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Text('Temperature: ${weatherData!['main']['temp']}°C'),
              Text('Condition: ${weatherData!['weather'][0]['description']}'),
              Text('Humidity: ${weatherData!['main']['humidity']}%'),
              Text('Wind Speed: ${weatherData!['wind']['speed']} m/s'),
            ],
          ),
        ),
      ],
    );
  }

  String getWeatherAnimation(String mainCondition) {
    if (mainCondition.isEmpty) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'clouds':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunderstorm.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }
}
