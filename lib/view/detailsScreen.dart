import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling_app/controller/detailsController.dart';
import 'package:traveling_app/getxController/getx.dart';
import 'package:traveling_app/model/weatherModel.dart';
import 'package:traveling_app/services/weatherService.dart';
import 'package:traveling_app/widget/snackbar.dart';

class Detailsscreen extends StatefulWidget {
  final String imagePath;
  final double rating;
  final String category;
  final Color categoryColor;
  final String title;
  final String description;
  final String city;
  final String country;
  final double lat;
  final double lon;

  const Detailsscreen({
    super.key,
    required this.imagePath,
    required this.rating,
    required this.category,
    required this.categoryColor,
    required this.title,
    required this.description,
    required this.city,
    required this.country,
    required this.lat,
    required this.lon,
  });

  @override
  State<Detailsscreen> createState() => _DetailsscreenState();
}

class _DetailsscreenState extends State<Detailsscreen> {
  Weather? weather;
  bool isWeatherLoading = true;

  final MainGetxController getXController = Get.put(MainGetxController());
  bool isFavorite = false;
  List<Map<String, dynamic>> favoriteTrips = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
    loadWeather();
  }

  Future<void> loadWeather() async {
    final result = await fetchWeather(widget.lat, widget.lon);

    setState(() {
      weather = result;
      isWeatherLoading = false;
    });
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('favorite_trips') ?? [];
    setState(() {
      favoriteTrips = favList
          .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
          .toList();
      isFavorite = favoriteTrips.any((trip) => trip['title'] == widget.title);
    });
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    if (isFavorite) {
      favoriteTrips.removeWhere((trip) => trip['title'] == widget.title);
    } else {
      favoriteTrips.add({
        'title': widget.title,
        'imageUrl': widget.imagePath,
        'rating': widget.rating,
        'category': widget.category,
        'description': widget.description,
        'city': widget.city,
        'country': widget.country,
        'lat': widget.lat,
        'lon': widget.lon,
      });
    }
    final encodedList = favoriteTrips.map((trip) => jsonEncode(trip)).toList();
    await prefs.setStringList('favorite_trips', encodedList);
    getXController.loadSavedTrips();
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  IconData getWeatherIcon(String code) {
    if (code.contains('d')) return Icons.wb_sunny;
    if (code.contains('n')) return Icons.nights_stay;
    return Icons.cloud_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.network(
                  widget.imagePath,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 400,
                    color: Colors.grey[300],
                    child: Icon(Icons.image, size: 50),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.white.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () => Get.back(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black87,
                              size: 20,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: toggleFavorite,
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorite
                                      ? Colors.red
                                      : Colors.black87,
                                  size: 20,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              transform: Matrix4.translationValues(0, -30, 0),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      femousTag('ICONIC LANDMARK', Color(0xFF60D5F8)),
                      SizedBox(width: 8),
                      femousTag('HISTORIC', Color(0xFF60D5F8)),
                      SizedBox(width: 8),
                      femousTag('PHOTOGRAPHY', Color(0xFF60D5F8)),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    widget.title,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        '${widget.city}, ${widget.country}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      RatingBarIndicator(
                        rating: widget.rating,
                        itemBuilder: (context, index) =>
                            Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 18,
                        direction: Axis.horizontal,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Text(
                    widget.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.6,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: isWeatherLoading
                              ? Center(child: CircularProgressIndicator())
                              : weather == null
                              ? Center(child: Text("Weather unavailable"))
                              : Column(
                                  children: [
                                    Text(
                                      'TODAY',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: 8),

                                    Icon(
                                      getWeatherIcon(weather!.iconCode),
                                      color:
                                          getWeatherIcon(weather!.iconCode) ==
                                              Icons.wb_sunny
                                          ? Colors.orange
                                          : Colors.black,
                                      size: 36,
                                    ),

                                    SizedBox(height: 8),

                                    Text(
                                      "${weather!.temperature.toStringAsFixed(1)}°C",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),

                                    SizedBox(height: 4),

                                    Text(
                                      weather!.description,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await showDateSelectionDialog(
                          context,
                          widget.title,
                          widget.imagePath,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00B4D8),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_circle_outline, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Add to Itinerary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget femousTag(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color.withOpacity(0.8),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
