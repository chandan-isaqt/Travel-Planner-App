import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:traveling_app/getxController/getx.dart';
import 'package:traveling_app/view/loginScreen.dart';

class UserProfileScreen extends StatefulWidget {
  UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  String name = '';
  String email = '';

  final MainGetxController getXController = Get.put(MainGetxController());

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? 'No Name';
      email = prefs.getString('email') ?? 'No Email';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),

            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person, size: 50, color: Colors.blue),
            ),

            SizedBox(height: 15),

            Text(
              name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
            ),

            Text(email, style: TextStyle(color: Colors.grey)),

            SizedBox(height: 30),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SUPPORT',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            SizedBox(height: 10),

            Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.help_outline, color: Colors.blue),
                ),
                title: Text('Help & Support'),
                trailing: Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),
            ),

            Container(
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade100),
                color:
                    Colors.white, // Ensure the container has a background color
              ),
              child: ListTile(
                leading: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors
                        .blue
                        .shade50, // Background color of the icon container
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.info_outline, color: Colors.blue),
                ),
                title: Text(
                  'About App',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Icon(Icons.chevron_right, color: Colors.grey),
                onTap: () {},
              ),
            ),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.star, color: Colors.blue),
                  ),
                  SizedBox(width: 16),

                  Text(
                    "Rate app",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Spacer(),

                  InkWell(
                    onTap: () {
                      if (getXController.isRating.value) {
                        if (!Get.isSnackbarOpen) {
                          Get.snackbar(
                            "Oops! 😔",
                            "You already submitted your rating.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Color.fromARGB(255, 53, 62, 80),
                            colorText: Colors.white,
                            margin: EdgeInsets.all(10),
                            borderRadius: 8,
                            duration: Duration(seconds: 1),
                          );
                        }
                      } else {
                        Get.defaultDialog(
                          title: "Rate App",
                          backgroundColor: Colors.white,
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("How would you rate this app?"),
                              SizedBox(height: 10),
                              RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemBuilder: (context, _) =>
                                    const Icon(Icons.star, color: Colors.amber),
                                onRatingUpdate: (rating) {
                                  if (!getXController.isRating.value) {
                                    getXController.isRating.value = true;
                                    Get.back();

                                    if (!Get.isSnackbarOpen) {
                                      Get.snackbar(
                                        "Thank you! 🌟",
                                        "Your rating has been recorded.",
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Color.fromARGB(
                                          255,
                                          52,
                                          102,
                                          201,
                                        ),
                                        colorText: Colors.white,
                                        margin: EdgeInsets.all(10),
                                        borderRadius: 8,
                                        duration: Duration(seconds: 1),
                                      );
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    },
                    child: Icon(Icons.chevron_right, color: Colors.grey),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', false);
                  Get.offAll(() => LoginScreen());
                },
                icon: Icon(Icons.logout),
                label: Text(
                  'Logout',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 55),

            Text(
              'VERSION 2.4.0',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 10,
                letterSpacing: 1.2,
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
