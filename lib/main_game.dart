import 'dart:developer';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/chunk_generator_methods.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

import 'utils/typedefs.dart';

class MainGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, HasTappables {
  final WorldData worldData; //*riceve i dati del mondo da un launcher

  MainGame({required this.worldData}) {
    //*quando creo un MainGame assegno l'istanza creata al field mainRef del global instance
    globalGameReference.mainGameRef = this;
  }
  //*SIAMO NEL MAIN, il componente "root"
  //TAPPABLE per i click

  //qui creo una istanza e la metto a disposizione di tutti i componenti (getX)
  GlobalGameReference globalGameReference = Get.put(GlobalGameReference());

  PlayerComponent playerComponent = PlayerComponent();

  void placeBlockLogic(Vector2 blockPlacingPosition) {
    //*logic
    if (blockPlacingPosition.y > 0 &&
        blockPlacingPosition.y < chunkHeight &&
        GameMethods.playerIsWithinReach(blockPlacingPosition) &&
        GameMethods.getBlockAtIndexPosition(blockPlacingPosition) == null &&
        GameMethods.adjacentBlockExists(blockPlacingPosition)) {
//*replace
      GameMethods.replaceBlockAtWorldChuncks(Blocks.dirt, blockPlacingPosition);
      add(Blockcomponent(
          block: Blocks.dirt,
          blockIndex: blockPlacingPosition,
          chunkIndex: GameMethods.getChunkIndexFromPositionIndex(
              blockPlacingPosition)));
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
    Vector2 blockPlacingPosition =
        GameMethods.getIndexPostionFromPixels(info.eventPosition.game);
    placeBlockLogic(blockPlacingPosition);
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    camera.followComponent(playerComponent);
    //* creo tre chunk uno dietro l'altro
    GameMethods.addChunkToWorldChunks(
        ChunkGenerationMethods.generateChunk(-1), false); //chunck sinistro

    GameMethods.addChunkToWorldChunks(
        ChunkGenerationMethods.generateChunk(0), true); // chunck centrale
    GameMethods.addChunkToWorldChunks(
        ChunkGenerationMethods.generateChunk(1), true); // chunck destro
    //li mostro
    renderChunk(-1);
    renderChunk(0);
    renderChunk(1);

    // renderChunk(ChunkGenerationMethods.generateChunk());

    add(playerComponent);
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    print(keysPressed);
    super.onKeyEvent(event, keysPressed);
    //* a destra
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        keysPressed.contains(LogicalKeyboardKey.keyD)) {
      worldData.playerData.motionState = ComponentMotionState.walkingRight;
    }
    //*a sinistra
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        keysPressed.contains(LogicalKeyboardKey.keyA)) {
      worldData.playerData.motionState = ComponentMotionState.walkingLeft;
    }
    //*JUMP
    if (keysPressed.contains(LogicalKeyboardKey.space) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW)) {
      worldData.playerData.motionState = ComponentMotionState.jumping;
    }
    if (keysPressed.isEmpty) {
      //*non premo nulla
      worldData.playerData.motionState = ComponentMotionState.idle;
    }
    return KeyEventResult.ignored;
  }

  void renderChunk(int chunkIndex) {
    Chunk chunk = GameMethods.getChunk(chunkIndex);

    //iterate over the chunk

    chunk.asMap().forEach((int yIndex, List<Blocks?> rowOfBlocks) {
      rowOfBlocks.asMap().forEach((int xIndex, Blocks? block) {
        if (block != null) {
          add(Blockcomponent(
              block: block,
              chunkIndex: chunkIndex,
              blockIndex: Vector2(chunkIndex * chunkWidth + xIndex.toDouble(),
                  yIndex.toDouble())));
        }
      });
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    // print(WorldData.chunksThathShoudlBeRendered);
    worldData.chunksThathShoudlBeRendered
        .asMap()
        .forEach((int index, int chunkIndex) {
      if (!worldData.currentlyRenderedChunks.contains(chunkIndex)) {
        //*non ancora rendered
        //*DESTRA:
        if (chunkIndex >= 0) {
          if (worldData.rightWorldChunk[0].length ~/ chunkWidth <
              chunkIndex + 1) {
            GameMethods.addChunkToWorldChunks(
                ChunkGenerationMethods.generateChunk(chunkIndex), true);
          }
        } else {
          //*SINISTRA
          if (worldData.leftWorldChunk[0].length ~/ chunkWidth <
              chunkIndex.abs()) {
            GameMethods.addChunkToWorldChunks(
                ChunkGenerationMethods.generateChunk(chunkIndex), false);
          }
        }

        renderChunk(chunkIndex);
        worldData.currentlyRenderedChunks.add(chunkIndex);
      }
    });
  }
}
