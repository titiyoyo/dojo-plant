import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/lib/AnalyzedImage.dart';

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final Uint8List imageBytes;
  final AnalyzedImage aImage;

  const DisplayPictureScreen({
    super.key,
    required this.imageBytes,
    required this.aImage,
  });

  @override
  Widget build(BuildContext context) {
    String blurriness = this.aImage.getBlurriness().toString();

    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 487 / 451,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fitWidth,
                  alignment: FractionalOffset.topCenter,
                  image: Image.memory(imageBytes).image
                )
              ),
            )),
          SizedBox(
            width: 200.0,
            height: 100.0,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Blurriness: $blurriness'),
            )),
          ),
        ],
      ),
    );
  }
}
