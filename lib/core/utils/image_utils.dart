import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<File> createTempFile() async {
    final dir = await getTemporaryDirectory();
    final filePath = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    return File(filePath);
  }
}
