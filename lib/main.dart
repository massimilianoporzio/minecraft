import 'package:flutter/material.dart';
import 'package:minecraft/layout/game_layout.dart';

void main() {
  //*initialize
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: GameLayout(),
  ));
}
