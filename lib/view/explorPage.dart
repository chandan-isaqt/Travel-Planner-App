import 'dart:developer';
import 'dart:math' show Random;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:traveling_app/model/placeModel.dart';
import 'package:traveling_app/services/geoapify_service.dart';
import 'package:traveling_app/services/unsplash_service.dart';
import 'package:traveling_app/view/detailsScreen.dart';

class Explorpage extends StatefulWidget {
  final String value;
  Explorpage({Key? key, required this.value}) : super(key: key);

  @override
  State<Explorpage> createState() => _ExplorpageState();
}

class _ExplorpageState extends State<Explorpage> {
  List<Place> places = [];
  List<Place> filteredPlaces = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPlaces();
    searchController.addListener(_filterPlaces);
  }

  void _filterPlaces() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredPlaces = places
          .where((place) => place.name.toLowerCase().contains(query))
          .toList();
    });
  }

  Future<void> fetchPlaces() async {
    if (widget.value.isEmpty) {
      setState(() => isLoading = false);
      return;
    }
    final service = GeoapifyService();
    final coordinates = await service.searchPlace(widget.value);
    log("Coordinates: $coordinates");

    if (!mounted) return;

    if (coordinates != null) {
      final result = await service.getTouristSpots(
        coordinates['lat']!,
        coordinates['lon']!,
      );
      if (!mounted) return;
      setState(() {
        places = result;
        filteredPlaces = result;
        isLoading = false;
      });
    } else
      setState(() => isLoading = false);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.value,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '${filteredPlaces.length} interesting places found',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by title...',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Expanded(child: placesList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget placesList() {
    if (isLoading) return Center(child: CircularProgressIndicator());
    if (filteredPlaces.isEmpty) return Center(child: Text("No places found"));

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: filteredPlaces.length,
      itemBuilder: (context, index) {
        final place = filteredPlaces[index];
        return FutureBuilder<String>(
          future: getimage(place.city, place.name),
          builder: (context, snapshot) {
            final imageUrl = snapshot.data?.isNotEmpty == true
                ? snapshot.data!
                : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbPe8LSZiRWjA7alDYwi6TrSyZEK4uPQds9A&s';
            return Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: placeCard(
                imagePath: imageUrl,
                rating: 3 + Random().nextDouble() * 2,
                category: place.category.toUpperCase(),
                categoryColor: Colors.blue,
                title: place.name,
                description: place.address,
                duration: place.city,
                country: place.country,
                lat: place.lat,
                lon: place.lon,
              ),
            );
          },
        );
      },
    );
  }

  Widget placeCard({
    required String imagePath,
    required double rating,
    required String category,
    required Color categoryColor,
    required String title,
    required String description,
    required String duration,
    required double lat,
    required double lon,
    required String country,
  }) {
    return InkWell(
      onTap: () {
        Get.to(
          Detailsscreen(
            imagePath: imagePath,
            rating: rating,
            category: category,
            categoryColor: categoryColor,
            title: title,
            description: description,
            city: duration,
            country: country,
            lat: lat,
            lon: lon,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 50,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 14),
                        SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14,
                        color: Colors.grey[600],
                      ),
                      SizedBox(width: 4),
                      Text(
                        duration,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      SizedBox(width: 16),
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Open",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "Details",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.blue,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
