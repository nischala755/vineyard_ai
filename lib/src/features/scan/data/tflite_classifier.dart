import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

import '../domain/scan_result.dart';

class LeafClassifier {
  LeafClassifier._(this._interpreter, this._labels);
  final Interpreter _interpreter;
  final List<String> _labels;

  static Future<LeafClassifier> create() async {
    final labels = (await rootBundle.loadString('assets/ml/labels.txt')).split(RegExp(r'\r?\n')).where((line) => line.trim().isNotEmpty).toList(growable: false);
    final interpreter = await Interpreter.fromAsset('assets/ml/grape_disease_int8.tflite', options: InterpreterOptions()..threads = 2);
    return LeafClassifier._(interpreter, labels);
  }

  ScanResult classify(String path) {
    final decoded = img.decodeImage(File(path).readAsBytesSync());
    if (decoded == null) throw StateError('The selected image cannot be decoded.');
    final inputShape = _interpreter.getInputTensor(0).shape;
    final size = inputShape[1];
    final image = img.copyResize(decoded, width: size, height: size);
    final input = _input(image, size);
    final output = List<List<int>>.filled(1, List<int>.filled(_labels.length, 0));
    _interpreter.run(input, output);
    final scores = output.first.map((v) => v / 255.0).toList(growable: false);
    final index = scores.indexOf(scores.reduce((a, b) => a > b ? a : b));
    return ScanResult(label: _labels[index], confidence: scores[index], imagePath: path, createdAt: DateTime.now());
  }

  Uint8List _input(img.Image image, int size) {
    final bytes = Uint8List(size * size * 3);
    var offset = 0;
    for (var y = 0; y < size; y++) {
      for (var x = 0; x < size; x++) {
        final pixel = image.getPixel(x, y);
        bytes[offset++] = pixel.r.toInt(); bytes[offset++] = pixel.g.toInt(); bytes[offset++] = pixel.b.toInt();
      }
    }
    return bytes;
  }

  void dispose() => _interpreter.close();
}
