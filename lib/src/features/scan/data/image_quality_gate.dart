import 'dart:io';
import 'package:image/image.dart' as img;

class ImageQualityGate {
  static String? validate(String path) {
    final source = img.decodeImage(File(path).readAsBytesSync());
    if (source == null) return 'This file is not a supported image.';
    final preview = img.copyResize(source, width: 128, height: 128);
    final pixels = <double>[];
    for (final p in preview) {
      pixels.add(.2126 * p.r + .7152 * p.g + .0722 * p.b);
    }
    final mean = pixels.reduce((a, b) => a + b) / pixels.length;
    final variance =
        pixels.map((v) => (v - mean) * (v - mean)).reduce((a, b) => a + b) /
            pixels.length;
    if (mean < 35)
      return 'This photo is too dark. Move to brighter, even light and scan again.';
    if (variance < 120)
      return 'This photo appears too blurred or uniform. Hold steady and keep the leaf in focus.';
    return null;
  }
}
