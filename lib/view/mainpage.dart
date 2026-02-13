import 'package:flutter/material.dart';
import 'package:traveling_app/view/homeScreen.dart';
import 'package:traveling_app/view/itineraryMain.dart';

import 'package:traveling_app/view/profileScreen.dart';
import 'package:traveling_app/view/saveTripSreen.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key});

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int currentIndex = 0;

  final pages = [
    HomeScreen(),
    MainItineraryScreen(),
    SavedTripsScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFF101623),
      body: pages[currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() => currentIndex = index);
        },
        // backgroundColor: const Color(0xFF101623),
        backgroundColor: Color(0xFFF6F6F8),

        selectedItemColor: Color(0xFF00BCD4),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Itinerary",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: "Saved"),

          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
