import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/layout/game_layout.dart';

void main() async {
  //*initialize
  WidgetsFlutterBinding.ensureInitialized();
  //load
  await Flame.images
      .load('sprite_sheets/blocks/block_breaking_sprite_sheet.png');
  await Flame.images
      .load('sprite_sheets/player/player_walking_sprite_sheet.png');

  await Flame.images.load('sprite_sheets/player/player_idle_sprite_sheet.png');
  await Flame.images.load('sprite_sheets/blocks/block_sprite_sheet_mod.png');
  runApp(const MaterialApp(
    home: GameLayout(),
  ));
}
