import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/layout/controller_widget.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot.dart';
import 'package:minecraft/widgets/inventory/inventory_storage_widget.dart';
import 'package:minecraft/widgets/inventory/item_bar.dart';
import 'package:minecraft/widgets/inventory/player_inventory_widget.dart';

import '../main_game.dart';

class GameLayout extends StatelessWidget {
  const GameLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //*This is the main game
        //Passo i dati di un mondo
        GameWidget(game: MainGame(worldData: WorldData(seed: 98765493))),
        //*here comes the hud
        const ControllerWidget(),
        const ItemBarWidget(),
        const PlayerInventoryWidget()
      ],
    );
  }
}
