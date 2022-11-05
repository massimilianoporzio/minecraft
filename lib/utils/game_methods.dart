import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/constants.dart';

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
}
