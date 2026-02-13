import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling_app/view/saveTripSreen.dart';

class MainGetxController extends GetxController {
  RxBool isLoggedIn = false.obs;
  RxBool isLoading = true.obs;

  // ==================mainpage==========
  RxString searchText = ''.obs;

  // =======tripHistory==
  var trips = <Trip>[].obs;
  @override
  void onInit() {
    super.onInit();
    loadSavedTrips();

    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    isLoggedIn.value = prefs.getBool('isLoggedIn') ?? false;
    isLoading.value = false;
  }

  Future<void> loadSavedTrips() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTrips = prefs.getStringList('favorite_trips') ?? [];

    final loadedTrips = savedTrips.map((e) {
      final map = Map<String, dynamic>.from(jsonDecode(e));
      return Trip(
        title: map['title'] ?? '',
        imageUrl: map['imageUrl'] ?? '',
        rating: (map['rating'] ?? 0).toDouble(),
        category: map['category'] ?? '',
        description: map['description'] ?? '',
        city: map['city'] ?? '',
        country: map['country'] ?? '',
        lat: (map['lat'] ?? 0).toDouble(),
        lon: (map['lon'] ?? 0).toDouble(),
      );
    }).toList();

    trips.value = loadedTrips;
  }

  RxBool isRating = false.obs;
}
