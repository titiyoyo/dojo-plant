import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as Img;
import 'package:opencv_4/factory/pathfrom.dart';
import 'package:opencv_4/opencv_4.dart' as cv2;
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  print(cameras);

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

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
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  Future<String> getAssetPath(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    var file = File("${directory.path}/assets/${imagePath}");
    return file.path;
  }

  double? computeVariance(Uint8List? values) {
    if (values == null) {
      return null;
    }

    final length = values.length;
    final mean = values.reduce((a, b) => a + b) / length;
    final se = values.map((e) => pow(e - mean, 2));
    return se.reduce((a, b) => a + b) / se.length;
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
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
                      aspectRatio: 1,
                      child: CameraPreview(_controller)),
                ),
                Positioned(
                    bottom: screenHeight * 0.25,
                    left: 0.0,
                    right: 0.0,
                    top: screenHeight * 0.25,
                    child: CustomPaint(
                      painter: BorderPainter(),
                    )
                ),
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

            Directory appDocDirectory = await getApplicationDocumentsDirectory();

            final greyScaleImage = await cv2.Cv2.cvtColor(
                pathString: "https://images.ctfassets.net/u4vv676b8z52/6Gb68j3cdLoe6wLn8qN6V2/c551e69e8bc614e80b29deb2e050adf4/blurry-vision-at-night-678x446.gif?fm=jpg&q=80",
                pathFrom: CVPathFrom.URL,
                outputType: cv2.Cv2.COLOR_BGR2GRAY
            );

            await Img.writeFile("${appDocDirectory.path}/img.test", greyScaleImage ?? Uint8List.fromList([]));
            final laplacian = await cv2.Cv2.laplacian(
              pathString: "${appDocDirectory.path}/img.test",
              pathFrom: CVPathFrom.URL,
              depth: 0,
            );

            //double? variance = this.computeVariance(Uint8List.fromList([1,2,3,4]));
            double? variance = this.computeVariance(laplacian);
            print(variance);

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imageBytes: laplacian == null ? Uint8List.fromList([1,2,3,4]) : laplacian
                ),
              ),
            );
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

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final Uint8List imageBytes;

  const DisplayPictureScreen({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Center(
        child: AspectRatio(
          aspectRatio: 487 / 451,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fitWidth,
                alignment: FractionalOffset.topCenter,
                // image: Image.file(File(imagePath)).image,
                image: Image.memory(this.imageBytes).image
              )
            ),
          ),
        ),
      ),
    );
  }
}

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final width = 3.0;
    final radius = 20.0;
    final tRadius = 2 * radius;
    final rect = Rect.fromLTWH(
      width,
      width,
      size.width - 2 * width,
      size.height - 2 * width,
    );
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final clippingRect0 = Rect.fromLTWH(
      0,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect1 = Rect.fromLTWH(
      size.width - tRadius,
      0,
      tRadius,
      tRadius,
    );
    final clippingRect2 = Rect.fromLTWH(
      0,
      size.height - tRadius,
      tRadius,
      tRadius,
    );
    final clippingRect3 = Rect.fromLTWH(
      size.width - tRadius,
      size.height - tRadius,
      tRadius,
      tRadius,
    );

    final path = Path()
      ..addRect(clippingRect0)
      ..addRect(clippingRect1)
      ..addRect(clippingRect2)
      ..addRect(clippingRect3);

    canvas.clipPath(path);
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = width,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class BarReaderSize {
  static double width = 200;
  static double height = 200;
}
