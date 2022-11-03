import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/main_game.dart';
import 'package:minecraft/widgets/controller_button.dart';

class ControllerWidget extends StatelessWidget {
  const ControllerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    MainGame mainGame = GlobalGameReference.instance.mainGameRef;
    //*una riga di controller buttons
    return Positioned(
      bottom: 100,
      left: 20,
      child: Row(
        children: [
          ControllerButton(
            path: "assets/controller/left_button.png",
            onTap: () {
              log("Controller left button has been pressed");
              //CAMBIO LO STATO
              mainGame.worldData.playerData.motionState =
                  ComponentMotionState.walkingLeft;
            },
          ),
          ControllerButton(
            path: "assets/controller/center_button.png",
            onTap: () {
              log("Controller center button has been pressed");
              mainGame.worldData.playerData.motionState =
                  ComponentMotionState.idle;
            },
          ),
          ControllerButton(
            path: "assets/controller/right_button.png",
            onTap: () {
              log("Controller right button has been pressed");

              mainGame.worldData.playerData.motionState =
                  ComponentMotionState.walkingRight;
            },
          ),
        ],
      ),
    );
  }
}
