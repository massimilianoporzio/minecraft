import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/layout/controller_widget.dart';

import '../main_game.dart';

class GameLayout extends StatelessWidget {
  const GameLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //*This is the main game
        //Passo i dati di un mondo
        GameWidget(game: MainGame(worldData: WorldData())),
        //*here comes the hud
        const ControllerWidget()
      ],
    );
  }
}
