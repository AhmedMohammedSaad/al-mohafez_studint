enum AspectRatioPreset {
  original,
  ratio2_3,
  ratio3_2,
  ratio3_4,
  ratio4_3,
  ratio9_16,
  ratio16_9,
}

class AspectRatioHelper {
  static double? getAspectRatio(AspectRatioPreset preset) {
    switch (preset) {
      case AspectRatioPreset.original:
        return null;
      case AspectRatioPreset.ratio2_3:
        return 2 / 3;
      case AspectRatioPreset.ratio3_2:
        return 3 / 2;
      case AspectRatioPreset.ratio3_4:
        return 3 / 4;
      case AspectRatioPreset.ratio4_3:
        return 4 / 3;
      case AspectRatioPreset.ratio9_16:
        return 9 / 16;
      case AspectRatioPreset.ratio16_9:
        return 16 / 9;
    }
  }
}
