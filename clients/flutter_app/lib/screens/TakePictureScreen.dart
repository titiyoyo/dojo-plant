import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_app/AppDrawer.dart';
import 'package:flutter_app/lib/AnalyzedImage.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;

import '../BorderPainter.dart';
import 'DisplayPictureScreen.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      // Get a specific camera from the list of available cameras.
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<Uint8List> getAssetPath(String imagePath) async {
    // final directory = await getApplicationDocumentsDirectory();
    // var file = File("${directory.path}/assets/${imagePath}");
    // return file.path;

    final data = await DefaultAssetBundle.of(context).load(imagePath);
    return data.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      drawer: Appdrawer(),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            // return CameraPreview(_controller);
            return Stack(
              children: [
                Positioned.fill(
                  child: AspectRatio(
                      aspectRatio: 1, child: CameraPreview(_controller)),
                ),
                Positioned(
                    bottom: screenHeight * 0.25,
                    left: 0.0,
                    right: 0.0,
                    top: screenHeight * 0.25,
                    child: CustomPaint(
                      painter: BorderPainter(),
                    )),
                // Positioned(
                //   bottom : 0,
                //   child: Container(), //other widgets like capture etc here
                // ),
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            if (!context.mounted) return;

            final imagePath = await _controller.takePicture();
            cv.Mat image = cv.imread(imagePath.path);

            AnalyzedImage aImage = AnalyzedImage(
                path: imagePath.path,
                image: image
            );

            print(aImage.getBlurriness());

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => DisplayPictureScreen(
                // Pass the automatically generated path to
                // the DisplayPictureScreen widget.
                imageBytes: cv.imencode(".jpg", image).$2,
                aImage: aImage,
              )
            ));
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}