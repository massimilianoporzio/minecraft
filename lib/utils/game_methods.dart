import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:minecraft/utils/constants.dart';

class GameMethods {
  static GameMethods get instance {
    return GameMethods();
  }

  Vector2 get getBlockSize {
    return Vector2.all(getScreenSize().width / chunkWidth);
  }

  static Size getScreenSize() {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  }
}
