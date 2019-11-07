import 'package:flutter/widgets.dart';

class AppAssets {

  AssetImage getImageAsset(String imagePath) { // image path is defined in pubspec.yaml file - assets/images/flutter.png
    return AssetImage(imagePath);
  }


}