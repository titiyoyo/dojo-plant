import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/screens/takePictureScreen.dart';

import '../AppDrawer.dart';
import '../globals.dart' as globals;

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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter a search term',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Enter your username',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TakePictureScreen(camera: globals.camera))
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
          )
        ],
      )
    );
  }
}
