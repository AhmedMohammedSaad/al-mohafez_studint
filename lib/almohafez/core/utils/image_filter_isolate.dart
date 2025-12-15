import 'package:flutter/services.dart';

import 'image_utils.dart';

import 'dart:io';
import 'dart:isolate';
import 'package:image/image.dart' as img;

void filterIsolate(FilterIsolateData data) async {
  try {
    // ✅ Must be called at the beginning
    BackgroundIsolateBinaryMessenger.ensureInitialized(data.rootIsolateToken);

    final imageBytes = await File(data.imagePath).readAsBytes();
    final decodedImage = img.decodeImage(imageBytes);

    if (decodedImage == null) {
      data.sendPort.send(null);
      return;
    }

    final matrix = data.filterMatrix;

    for (int y = 0; y < decodedImage.height; y++) {
      for (int x = 0; x < decodedImage.width; x++) {
        final pixel = decodedImage.getPixel(x, y);
        final r = pixel.r;
        final g = pixel.g;
        final b = pixel.b;
        final a = pixel.a;

        final newR = _clamp((r * matrix[0] + g * matrix[1] + b * matrix[2] + a * matrix[3] + matrix[4]).round());
        final newG = _clamp((r * matrix[5] + g * matrix[6] + b * matrix[7] + a * matrix[8] + matrix[9]).round());
        final newB = _clamp((r * matrix[10] + g * matrix[11] + b * matrix[12] + a * matrix[13] + matrix[14]).round());
        final newA = _clamp((r * matrix[15] + g * matrix[16] + b * matrix[17] + a * matrix[18] + matrix[19]).round());

        decodedImage.setPixelRgba(x, y, newR, newG, newB, newA);
      }
    }

    final output = await ImageUtils.createTempFile(); // This needs the root token
    await output.writeAsBytes(img.encodeJpg(decodedImage));

    data.sendPort.send(output);
  } catch (e) {
    data.sendPort.send(null);
  }
}

int _clamp(int val) => val.clamp(0, 255);

class FilterIsolateData {
  // ✅ Add this

  FilterIsolateData({
    required this.imagePath,
    required this.filterMatrix,
    required this.sendPort,
    required this.rootIsolateToken, // ✅ Pass this too
  });
  final String imagePath;
  final List<double> filterMatrix;
  final SendPort sendPort;
  final RootIsolateToken rootIsolateToken;
}
