import 'dart:developer';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:minecraft/components/block_breaking_component.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/components/item_component.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/chunk_generator_methods.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

import 'resources/items.dart';
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
        GameMethods.adjacentBlockExists(blockPlacingPosition) &&
        worldData
                .inventoryManager
                .inventorySlots[
                    worldData.inventoryManager.currentSelectedSlot.value]
                .block !=
            null &&
        worldData
            .inventoryManager
            .inventorySlots[
                worldData.inventoryManager.currentSelectedSlot.value]
            .block is Blocks) {
      //* piazzo solo i blocchi non gli items
//*replace
      GameMethods.replaceBlockAtWorldChuncks(
          worldData
              .inventoryManager
              .inventorySlots[
                  worldData.inventoryManager.currentSelectedSlot.value]
              .block,
          blockPlacingPosition);
      //*USO add(BlockData ecc) perchése è una CRAFTINGTABLE voglio fare add di una istanza di quella classe!
      // add(BlockComponent(
      //     block: worldData
      //         .inventoryManager
      //         .inventorySlots[
      //             worldData.inventoryManager.currentSelectedSlot.value]
      //         .block!,
      //     blockIndex: blockPlacingPosition,
      //     chunkIndex: GameMethods.getChunkIndexFromPositionIndex(
      //         blockPlacingPosition)));

      add(BlockData.getParentForBlock(
          worldData
              .inventoryManager
              .inventorySlots[
                  worldData.inventoryManager.currentSelectedSlot.value]
              .block!,
          blockPlacingPosition,
          GameMethods.getChunkIndexFromPositionIndex(blockPlacingPosition)));

      worldData.inventoryManager
          .inventorySlots[worldData.inventoryManager.currentSelectedSlot.value]
          .decrementSlot();
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    // print("MAIN GAME TAP DOWN");
    super.onTapDown(pointerId, info);
    Vector2 blockPlacingPosition =
        GameMethods.getIndexPostionFromPixels(info.eventPosition.game);
    placeBlockLogic(blockPlacingPosition);
  }

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    camera.followComponent(playerComponent);

    add(playerComponent);

    //*uso Future e Timer per essere sicuro che sia già costruito
    //*DOPO UN SECONDO AGGIUNGO LA CRAFTING TABLE
    Future.delayed(Duration(seconds: 1)).then((value) {
      GlobalGameReference.instance.mainGameRef.worldData.inventoryManager
          .addBlockToInventory(Blocks.craftingTable); //*per debug
      worldData.inventoryManager.addBlockToInventory(Items.apple);
      worldData.inventoryManager.addBlockToInventory(Items.ironIngot);
      worldData.inventoryManager.addBlockToInventory(Items.ironIngot);
      worldData.inventoryManager.addBlockToInventory(Blocks.birchPlank);
      worldData.inventoryManager.addBlockToInventory(Blocks.birchPlank);
      worldData.inventoryManager.addBlockToInventory(Blocks.birchPlank);
      worldData.inventoryManager.addBlockToInventory(Blocks.birchPlank);
      worldData.inventoryManager.addBlockToInventory(Items.stick);
      worldData.inventoryManager.addBlockToInventory(Items.stick);

      worldData.inventoryManager.addBlockToInventory(Blocks.furnace);
    });
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    // print(keysPressed);
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
    if (keysPressed.contains(LogicalKeyboardKey.keyI)) {
      GlobalGameReference.instance.mainGameRef.worldData.inventoryManager
              .inventoryIsOpen.value =
          !GlobalGameReference.instance.mainGameRef.worldData.inventoryManager
              .inventoryIsOpen.value;
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
          //*AGGIUNGO O IL BLOCCO STD O la CRAFTING
          //*USO add(BlockData ecc) perchése è una CRAFTINGTABLE voglio fare add di una istanza di quella classe!
          add(BlockData.getParentForBlock(
              block,
              Vector2(chunkIndex * chunkWidth + xIndex.toDouble(),
                  yIndex.toDouble()),
              chunkIndex));
        }
      });
    });
  }

  void itemRenderingLogic() {
    //*guardo se ci sono items da agg (render)
    worldData.items.asMap().forEach((int index, ItemComponent item) {
      if (!item.isMounted) {
        if (worldData.chunksThathShoudlBeRendered.contains(
            GameMethods.getChunkIndexFromPositionIndex(item.spawnBlockIndex))) {
          add(item);
        }
      } else {
        //*l'indice dell'item NON è quello del chunk che viene mostrato
        //* UN-RENDER IT!
        if (!worldData.chunksThathShoudlBeRendered.contains(
            GameMethods.getChunkIndexFromPositionIndex(item.spawnBlockIndex))) {
          remove(item);
        }
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    itemRenderingLogic();

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
