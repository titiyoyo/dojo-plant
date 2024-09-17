import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';

import 'package:flutter_app/screens/TakePictureScreen.dart';
import 'package:flutter_app/screens/LoginScreen.dart';
import 'package:flutter_app/screens/GPSOffScreen.dart';

import 'globals.dart' as globals;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();
  globals.camera = cameras.first;
  await dotenv.load(fileName: '.env');
  await globals.setGlobals();

  globals.permission = await Geolocator.requestPermission();

  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      home: getHomepage()
    ),
  );
}

getHomepage() {
  String? token = globals.token;
  late Widget home;

  if (globals.permission != LocationPermission.whileInUse
      && globals.permission != LocationPermission.always
  ) {
    home = GPSOffScreen();
  } else if (token == null) {
    home = LoginScreen();
  } else {
    home = TakePictureScreen(camera: globals.camera);
  }

  return home;
}

extension StringCasingExtension on String {
  String get toCapitalized => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized).join(' ');
}

class BarReaderSize {
  static double width = 200;
  static double height = 200;
}
