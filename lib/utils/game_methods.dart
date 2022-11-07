import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/typedefs.dart';

class GameMethods {
  static GameMethods get instance {
    return GameMethods();
  }

  static double get playerXIndexPosition {
    return GlobalGameReference.instance.mainGameRef.playerComponent.position.x /
        getBlockSize().x;
  }

  static Vector2 getBlockSize() {
    // return Vector2.all(getScreenSize().width / chunkWidth) *0.6; //* SOLO PER DEBUG
    return Vector2.all(30);
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

  static Future<SpriteSheet> getBlockSpriteSheet() async {
    return SpriteSheet(
        image: await Flame.images
            .load('sprite_sheets/blocks/block_sprite_sheet.png'),
        srcSize: Vector2.all(60));
  }

  static Future<Sprite> getSpriteFromBlock(Blocks block) async {
    SpriteSheet spriteSheet = await getBlockSpriteSheet();
    return spriteSheet.getSprite(0, block.index);
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
}
