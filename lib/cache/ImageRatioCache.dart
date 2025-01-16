import 'dart:async';

import 'package:flutter/cupertino.dart';

class ImageRatioCache {
  static final Map<String, double> _cache = {};

  static Future<double> get(String imagePath) async {
    if (_cache.containsKey(imagePath)) {
      return _cache[imagePath]!;
    }
    final ratio = await getImageAspectRatio(imagePath);
    _cache[imagePath] = ratio;
    return ratio;
  }

  static Future<double> getImageAspectRatio(String imagePath) async {
    final Completer<Size> completer = Completer();
    final Image image = Image.asset(imagePath);

    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        final Size size = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        completer.complete(size);
      }),
    );

    final Size size = await completer.future;
    return size.width / size.height;
  }
}
