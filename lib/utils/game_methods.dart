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

  static Vector2 getBlockSize() {
    // return Vector2.all(getScreenSize().width / chunkWidth) *0.6; //* SOLO PER DEBUG
    return Vector2.all(30);
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
    return (chunkHeight * 0.2).toInt();
  }

  static void addChunckToRightWorldChunks(Chunk chunk) {
    Chunk rightWorldChunk =
        GlobalGameReference.instance.mainGameRef.worldData.rightWorldChunk;
    //* yIndex è l'indice di riga
    chunk.asMap().forEach((int yIndex, List<Blocks?> value) {
      //AGGIUNGO ALLA RIGA (A DESTRA!)
      //*ACCEDO AL CORRENTE RIGHT WORLD CHUNK e gli aggiungo la riga di blocks
      rightWorldChunk[yIndex].addAll(value);
    });
  }

  static Chunk getChunk(int chunkIndex) {
    //prendo il chunk destro globale
    Chunk rightWorldChunk =
        GlobalGameReference.instance.mainGameRef.worldData.rightWorldChunk;
    Chunk chunk = [];
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
    return chunk;
  }
}
