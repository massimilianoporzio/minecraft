import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/typedefs.dart';

import '../resources/items.dart';

enum Direction { top, bottom, left, right }

enum SlotType { inventory, itemBar, crafting, craftingOutput }

class GameMethods {
  static GameMethods get instance {
    return GameMethods();
  }

  static double get playerXIndexPosition {
    return GlobalGameReference.instance.mainGameRef.playerComponent.position.x /
        blockSize.x;
  }

  static double get playerYIndexPosition {
    return GlobalGameReference.instance.mainGameRef.playerComponent.position.y /
        blockSize.y;
  }

  static Vector2 get blockSize {
    return Vector2.all(getScreenSize().width / chunkWidth) * 0.6;
    //return Vector2.all(20); //* SOLO PER DEBUG
  }

  static double get slotSize {
    return 0.075 * getScreenSize().height;
  }

  static double get gravity {
    return 0.8 * blockSize.x;
  }

  static int get currentChunk {
    return playerXIndexPosition >= 0
        ? playerXIndexPosition ~/ chunkWidth
        : playerXIndexPosition ~/ chunkWidth - 1;
  }

  static int get maxSecondarySoilExtent {
    return freeArea + 6; //*DAL TERRENO SCENDO DI 6
  }

  static Size getScreenSize() {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  }

  static SpriteSheet getBlockSpriteSheet() {
    return SpriteSheet(
        image: Flame.images
            .fromCache('sprite_sheets/blocks/block_sprite_sheet_mod.png'),
        srcSize: Vector2.all(60));
  }

  static SpriteSheet getItemSpriteSheet() {
    return SpriteSheet(
        image: Flame.images
            .fromCache('sprite_sheets/item/item_sprite_sheet_mod.png'),
        srcSize: Vector2.all(60));
  }

  static Sprite getSpriteFromBlock(Blocks block) {
    SpriteSheet spriteSheet = getBlockSpriteSheet();
    return spriteSheet.getSprite(0, block.index);
  }

  static Sprite getSpriteFromItem(Items item) {
    SpriteSheet spriteSheet = getItemSpriteSheet();
    return spriteSheet.getSprite(0, item.index);
  }

  //return WHERE terrain will start
  static int get freeArea {
    return (chunkHeight * 0.4).toInt();
  }

  static void addChunkToWorldChunks(Chunk chunk, bool isRight) {
    if (isRight) {
      Chunk rightWorldChunk =
          GlobalGameReference.instance.mainGameRef.worldData.rightWorldChunk;
//* yIndex è l'indice di riga
      chunk.asMap().forEach((int yIndex, List<Blocks?> value) {
        //AGGIUNGO ALLA RIGA (A DESTRA!)
        //*ACCEDO AL CORRENTE RIGHT WORLD CHUNK e gli aggiungo la riga di blocks
        rightWorldChunk[yIndex].addAll(value);
      });
    } else {
      //*AGG A SINISTRA
      Chunk leftWorldChunk =
          GlobalGameReference.instance.mainGameRef.worldData.leftWorldChunk;
      chunk.asMap().forEach((int yIndex, List<Blocks?> value) {
        //AGGIUNGO ALLA RIGA (A DESTRA!)
        //*ACCEDO AL CORRENTE LEFT WORLD CHUNK e gli aggiungo la riga di blocks
        leftWorldChunk[yIndex].addAll(value);
      });
    }
  }

  static Chunk getChunk(int chunkIndex) {
    //prendo il chunk destro globale
    Chunk rightWorldChunk =
        GlobalGameReference.instance.mainGameRef.worldData.rightWorldChunk;

    Chunk leftWorldChunk =
        GlobalGameReference.instance.mainGameRef.worldData.leftWorldChunk;

    Chunk chunk = [];
    if (chunkIndex >= 0) {
      rightWorldChunk.asMap().forEach((int index, List<Blocks?> rigaDiBlocchi) {
        //*per ogni riga di blocchi prendo il chunck (largo 16) che mi interessa
        //*ES:
        ///* 3 chunck 16 erba e 16 sabbia e 16 erba
        //* [g,g,g,g,g,g,g,g,g,g,g,g,g,g,g,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,g,g,g,g,g,g,g,g,g,g,g,g,g,g,g]
        //* voglio estrarre un chunk (largo 16!) a partire da un indice (es il secondo chunk in quella riga)
        ///
        chunk.add(rigaDiBlocchi.sublist(
            chunkWidth * chunkIndex, chunkWidth * (chunkIndex + 1)));
      });
    } else {
      //FLIP HORIZONTALY

      leftWorldChunk.asMap().forEach((int index, List<Blocks?> rigaDiBlocchi) {
        //UNO SHIFTATO
        chunk.add(rigaDiBlocchi
            .sublist(chunkWidth * (chunkIndex.abs() - 1),
                chunkWidth * (chunkIndex.abs()))
            .reversed
            .toList());
      });
    }

    return chunk;
  }

  static IntNoise processNoise(RawNoise rawNoise) {
    IntNoise processedNoise = List.generate(
        rawNoise.length,
        (index) => List.generate(
              rawNoise[0].length,
              (index) => 255,
            ));
    for (var x = 0; x < rawNoise.length; x++) {
      for (var y = 0; y < rawNoise[0].length; y++) {
        var value = (0x80 + 0x80 * rawNoise[x][y]).floor(); // grayscale 0-255
        processedNoise[x][y] = value;
      }
    }
    return processedNoise;
  }

  static int getChunkIndexFromPositionIndex(Vector2 positionIndex) {
    int index = positionIndex.x >= 0
        ? (positionIndex.x ~/ chunkWidth)
        : (positionIndex.x ~/ chunkWidth) - 1;
    // print("CHUNK INDEX IS: $index");
    return index;
  }

  static Vector2 getIndexPostionFromPixels(Vector2 clickPosition) {
    return Vector2((clickPosition.x / blockSize.x).floorToDouble(),
        (clickPosition.y / blockSize.y).floorToDouble());
  }

  static void replaceBlockAtWorldChuncks(Blocks? block, Vector2 blockIndex) {
    if (blockIndex.x >= 0) {
      //*replace in the rightWorldChunck
      GlobalGameReference.instance.mainGameRef.worldData
          .rightWorldChunk[blockIndex.y.toInt()][blockIndex.x.toInt()] = block;
    } else {
      //*in leftworldchunk
      GlobalGameReference.instance.mainGameRef.worldData
              .leftWorldChunk[blockIndex.y.toInt()]
          [blockIndex.x.toInt().abs() - 1] = block; //* -1 a sinistra
    }
  }

  static bool playerIsWithinReach(Vector2 positionIndex) {
    bool isPositionLeftToPlayer = positionIndex.x < playerXIndexPosition;
    bool isPositionTopToPlayer =
        positionIndex.y < playerYIndexPosition - GameMethods.blockSize.y;
    // print("isLeft?: $isPositionLeftToPlayer");
    // print("isTop?: $isPositionTopToPlayer");

    int reach = (isPositionLeftToPlayer || isPositionTopToPlayer)
        ? maxReach + 1
        : maxReach;
    // print("reach is $reach");

    if ((positionIndex.x - playerXIndexPosition).abs() < reach &&
        (positionIndex.y - playerYIndexPosition).abs() < reach) {
      return true;
    }
    return false;
  }

  static Blocks? getBlockAtIndexPosition(Vector2 blockIndex) {
    if (blockIndex.x >= 0) {
      return GlobalGameReference.instance.mainGameRef.worldData
          .rightWorldChunk[blockIndex.y.toInt()][blockIndex.x.toInt()];
    } else {
      //*in leftworldchunk
      return GlobalGameReference.instance.mainGameRef.worldData
              .leftWorldChunk[blockIndex.y.toInt()]
          [blockIndex.x.toInt().abs() - 1]; //* -1 a sinistra
    }
  }

  static Blocks? getBlockAtDirection(Vector2 blockIndex, Direction direction) {
    switch (direction) {
      case Direction.top:
        //* dentro truy che ai bordi va in errore
        try {
          return getBlockAtIndexPosition(
              Vector2(blockIndex.x, blockIndex.y - 1));
        } catch (e) {
          break;
        }

      case Direction.bottom:
        try {
          return getBlockAtIndexPosition(
              Vector2(blockIndex.x, blockIndex.y + 1));
        } catch (e) {
          break;
        }
      case Direction.left:
        try {
          return getBlockAtIndexPosition(
              Vector2(blockIndex.x - 1, blockIndex.y));
        } catch (e) {
          break;
        }
      case Direction.right:
        try {
          return getBlockAtIndexPosition(
              Vector2(blockIndex.x + 1, blockIndex.y));
        } catch (e) {
          break;
        }
    }
    return null;
  }

  static bool adjacentBlockExists(Vector2 blockIndex) {
    //*TOP
    if (getBlockAtDirection(blockIndex, Direction.top) is Blocks) {
      return true;
    } else if (getBlockAtDirection(blockIndex, Direction.bottom) is Blocks) {
      return true;
    } else if (getBlockAtDirection(blockIndex, Direction.left) is Blocks) {
      return true;
    } else if (getBlockAtDirection(blockIndex, Direction.right) is Blocks) {
      return true;
    }
    return false;
  }
}
