import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/main_game.dart';

void main() {
  //*initialize
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GameWidget(game: MainGame()));
}
