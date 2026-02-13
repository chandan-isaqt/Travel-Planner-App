import 'package:flutter/material.dart';
import 'package:traveling_app/services/weatherService.dart';

import 'package:traveling_app/model/weatherModel.dart';

import 'package:geolocator/geolocator.dart';

class WeatherCard extends StatefulWidget {
  const WeatherCard({super.key});

  @override
  State<WeatherCard> createState() => _WeatherCardState();
}

class _WeatherCardState extends State<WeatherCard> {
  Weather? weather;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    LocationPermission permission = await Geolocator.checkPermission();
    if (!mounted) return;

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (!mounted) return;

      if (permission == LocationPermission.denied) {
        if (mounted) setState(() => isLoading = false);
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) setState(() => isLoading = false);
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;

      final data = await fetchWeather(position.latitude, position.longitude);
      if (!mounted) return;

      setState(() {
        weather = data;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      if (mounted) setState(() => isLoading = false);
    }
  }

  IconData getWeatherIcon(String code) {
    if (code.contains('d')) return Icons.wb_sunny;
    if (code.contains('n')) return Icons.nights_stay;
    return Icons.cloud_outlined;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (weather == null) {
      return Container(
        width: double.infinity,
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(
          child: Text(
            'Unable to fetch weather',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white, size: 16),
              const SizedBox(width: 4),
              Text(
                'Current Location',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather!.city,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    weather!.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    getWeatherIcon(weather!.iconCode),
                    color: Colors.white.withOpacity(0.9),
                    size: 36,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${weather!.temperature.toStringAsFixed(0)}°',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
