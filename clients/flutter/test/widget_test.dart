// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:camera/camera.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    WidgetsFlutterBinding.ensureInitialized();

    final cameras = await availableCameras();

    // Build our app and trigger a frame.
    await tester.pumpWidget(TakePictureScreen(camera: cameras.first));

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.camera));
    await tester.pump();
  });
}
