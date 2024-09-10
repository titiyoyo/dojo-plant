import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/TakePictureScreen.dart';
import 'package:camera/camera.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'globals.dart' as globals;
import 'screens/LoginScreen.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  globals.camera = cameras.first;
  await dotenv.load(fileName: ".env");

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: isLogged() ? TakePictureScreen(camera: globals.camera) : LoginScreen(),
    ),
  );
}

bool isLogged() {
  return true;
}

class BarReaderSize {
  static double width = 200;
  static double height = 200;
}
