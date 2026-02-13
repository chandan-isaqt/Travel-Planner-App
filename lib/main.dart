import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:traveling_app/getxController/getx.dart';
import 'package:traveling_app/view/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MainGetxController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Splash(),
    );
  }
}
