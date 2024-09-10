import 'package:opencv_dart/opencv_dart.dart' as cv;

class AnalyzedImage {
  final String path;
  final cv.Mat image;

  AnalyzedImage({
    required this.path,
    required this.image
  });

  getBlurriness() {
    cv.Mat gray = cv.cvtColor(this.image, cv.COLOR_BGR2GRAY);
    cv.Scalar blurriness =
    cv.laplacian(gray, cv.MatType.CV_64F).variance();

    return blurriness;
  }
}