import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling_app/getxController/getx.dart';
import 'detailsscreen.dart';

class SavedTripsScreen extends StatefulWidget {
  const SavedTripsScreen({super.key});

  @override
  State<SavedTripsScreen> createState() => _SavedTripsScreenState();
}

class _SavedTripsScreenState extends State<SavedTripsScreen> {
  final MainGetxController getXController = Get.put(MainGetxController());

  @override
  void initState() {
    super.initState();
    getXController.loadSavedTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text(
              'Saved Trips',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => Expanded(
                child: getXController.trips.isEmpty
                    ? const Center(child: Text("No favorite trips yet"))
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        itemCount: getXController.trips.length,
                        itemBuilder: (context, index) {
                          final trip = getXController.trips[index];
                          return TripCard(trip: trip);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Trip {
  final String title;
  final String imageUrl;
  final double rating;
  final String category;
  final String description;
  final String city;
  final String country;
  final double lat;
  final double lon;

  Trip({
    required this.title,
    required this.imageUrl,
    required this.rating,
    required this.category,
    required this.description,
    required this.city,
    required this.country,
    required this.lat,
    required this.lon,
  });
}

class TripCard extends StatelessWidget {
  final Trip trip;
  const TripCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Detailsscreen(
              imagePath: trip.imageUrl,
              rating: trip.rating,
              category: trip.category,
              categoryColor: Colors.blue,
              title: trip.title,
              description: trip.description,
              city: trip.city,
              country: trip.country,
              lat: trip.lat,
              lon: trip.lon,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Trip Image
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.grey[300]!, Colors.grey[400]!],
                ),
              ),
              child: trip.imageUrl.isEmpty
                  ? const Icon(Icons.image, size: 40, color: Colors.white70)
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        trip.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          size: 40,
                          color: Colors.white70,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Text(
                trip.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
