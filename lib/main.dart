import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/layout/game_layout.dart';
import 'package:minecraft/main_game.dart';

void main() {
  //*initialize
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: GameLayout(),
  ));
}
