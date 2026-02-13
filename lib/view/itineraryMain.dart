import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling_app/view/itinerary_page.dart';

class MainItineraryScreen extends StatefulWidget {
  const MainItineraryScreen({Key? key}) : super(key: key);

  @override
  State<MainItineraryScreen> createState() => _MainItineraryScreenState();
}

class _MainItineraryScreenState extends State<MainItineraryScreen> {
  List<Map<String, String>> trips = [];

  @override
  void initState() {
    super.initState();
    loadSavedTrips();
  }

  // Load trips from SharedPreferences
  Future<void> loadSavedTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTrips = prefs.getStringList('my_itinerary') ?? [];
    List<Map<String, String>> loadedTrips = [];

    for (String tripString in savedTrips) {
      Map<String, String> tripMap = {};
      String cleaned = tripString.replaceAll('{', '').replaceAll('}', '');
      List<String> parts = cleaned.split(', ');

      for (String part in parts) {
        List<String> keyValue = part.split(': ');
        if (keyValue.length == 2) {
          tripMap[keyValue[0]] = keyValue[1];
        }
      }

      loadedTrips.add(tripMap);
    }

    setState(() {
      trips = loadedTrips;
    });
  }

  Future<void> deleteTrip(int index) async {
    final prefs = await SharedPreferences.getInstance();

    trips.removeAt(index);

    List<String> updatedTrips = trips.map((tripMap) {
      return tripMap.entries
          .map((entry) => '${entry.key}: ${entry.value}')
          .join(', ');
    }).toList();

    await prefs.setStringList('my_itinerary', updatedTrips);

    setState(() {
      trips = trips;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Itinerary',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: trips.isEmpty
                  ? Center(
                      child: Text(
                        'No trips added yet.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      itemCount: trips.length,
                      itemBuilder: (context, index) {
                        final trip = trips[index];
                        return TripCard(
                          title: trip['title'] ?? '',
                          startDate: trip['startDate'] ?? '',
                          endDate: trip['endDate'] ?? '',
                          imageUrl: trip['imageUrl'] ?? '',
                          onDelete: () => deleteTrip(index),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TripCard extends StatelessWidget {
  final String title;
  final String startDate;
  final String endDate;
  final String imageUrl;
  final VoidCallback onDelete; // Callback for delete action

  const TripCard({
    Key? key,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
    required this.onDelete, // Initialize delete callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ItineraryPage(
            title: title,
            startDate: startDate,
            endDate: endDate,
            imageUrl: imageUrl,
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
                color: Colors.grey[200],
              ),
              child: imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image, color: Colors.grey),
                      ),
                    )
                  : const Center(child: Icon(Icons.image, color: Colors.grey)),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${startDate} - ${endDate}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),

            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
