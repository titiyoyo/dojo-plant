import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/lib/GPSWidget.dart';
import 'package:flutter_app/screens/takePictureScreen.dart';

import '../AppDrawer.dart';
import '../globals.dart' as globals;
import 'package:flutter_app/lib/TreesDropDown.dart';

class FormLabel extends Text {
  const FormLabel(super.data, {super.key});

  @override
  TextStyle? get style => const TextStyle(
      fontWeight: FontWeight.w500,
  );
}

class FormScreen extends StatelessWidget {
  final CameraDescription camera;

  const FormScreen({
    super.key,
    required this.camera
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Tree'),
      ),
      drawer: const Appdrawer(),
      body:
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FormLabel('Tree Type'),
                    TreesDropDown(contract: globals.currentContract)
                  ]
                )
            ),
            TextButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    CupertinoPageRoute(builder: (context) => TakePictureScreen(camera: globals.camera))
                );
              },
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Icon(Icons.camera_alt),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    ),
                    Text(
                      'Open Camera',
                      style: TextStyle(color: Colors.blue, fontSize: 15),
                    ),
                  ]
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                child: Container(
                    height: 100,
                    child: GpsWidget()
                )
            ),
          ],
        ),
      )
    );
  }
}
