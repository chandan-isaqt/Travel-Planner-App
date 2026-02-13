import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:traveling_app/getxController/getx.dart';
import 'package:traveling_app/view/loginScreen.dart';
import 'package:traveling_app/view/mainpage.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  late final MainGetxController controller;

  @override
  void initState() {
    super.initState();

    // Make sure controller is initialized
    controller = Get.find<MainGetxController>();

    startSplash();
  }

  void startSplash() {
    Timer(const Duration(seconds: 3), () {
      if (!mounted) return;

      if (controller.isLoggedIn.value) {
        Get.offAll(() => const Mainpage());
      } else {
        Get.offAll(() => const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE0F2FE), Color(0xFFF8FAFC), Color(0xFFE0F2FE)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Spacer(flex: 3),

            
            _LogoWidget(),

            SizedBox(height: 24),

            Text(
              'Smart Travel Planner',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                letterSpacing: -1,
              ),
            ),
            Text(
              'Plan smarter, travel better, explore further.',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),

            Spacer(flex: 2),

            SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
              ),
            ),

            SizedBox(height: 40),

            Text(
              'VERSION 2.4.0',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1.5,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _LogoWidget extends StatelessWidget {
  const _LogoWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset("assets/logo (1).png", fit: BoxFit.contain),
      ),
    );
  }
}
