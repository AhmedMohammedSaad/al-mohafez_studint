import 'dart:ui' as ui;

import 'package:flutter/services.dart';

Future<Uint8List> assetsToUnit8List(String path, int width) async {
  final ByteData data = await rootBundle.load(path);
  final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
  final ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
}
