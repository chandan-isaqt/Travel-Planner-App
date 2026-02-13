import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:traveling_app/getxController/getx.dart';
import 'package:traveling_app/services/unsplash_service.dart';
import 'package:traveling_app/view/explorPage.dart';
import 'package:traveling_app/widget/destinationCard.dart';
import 'package:traveling_app/widget/snackbar.dart';
import 'package:traveling_app/widget/weatherCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MainGetxController getXController = Get.put(MainGetxController());
  TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> popularDestinations = [
    {'city': 'Mumbai', 'country': 'India'},
    {'city': 'Delhi', 'country': 'India'},
    {'city': 'Kolkata', 'country': 'India'},
    {'city': 'Bengaluru', 'country': 'India'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Explore the world',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Where to next?',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => TextField(
                            controller: searchController,
                            onChanged: (value) {
                              getXController.searchText.value = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Search for a city...',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade400,
                                fontSize: 14,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade400,
                                size: 22,
                              ),

                              suffixIcon:
                                  getXController.searchText.value.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close, size: 20),
                                      color: Colors.grey.shade600,
                                      onPressed: () {
                                        searchController.clear();
                                        getXController.searchText.value = '';
                                      },
                                    )
                                  : null,

                              filled: true,
                              fillColor: Colors.grey.shade100,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Color(0xFF00BCD4),
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      InkWell(
                        onTap: () {
                          final value = searchController.text.trim();

                          if (value.isNotEmpty) {
                            Get.to(() => Explorpage(value: value));
                          } else {
                            TopSnackBar.show(
                              context,
                              message: 'Please enter a city name',
                              backgroundColor: Colors.red,
                              icon: Icons.error_outline,
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.blue,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Column(
                    children: [
                      WeatherCard(),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Popular Destinations',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: popularDestinations.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.75,
                            ),
                        itemBuilder: (context, index) {
                          final item = popularDestinations[index];

                          return FutureBuilder<String>(
                            future: getimage(item['city'], item['country']),
                            builder: (context, snapshot) {
                              final imageUrl = snapshot.data?.isNotEmpty == true
                                  ? snapshot.data!
                                  : 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSbPe8LSZiRWjA7alDYwi6TrSyZEK4uPQds9A&s';

                              return DestinationCard(
                                imageUrl: imageUrl,
                                city: item['city'],
                                country: item['country'],
                              );
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
