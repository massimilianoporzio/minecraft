import 'package:flame/components.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../resources/blocks.dart';

class ItemComponent extends SpriteComponent {
  final Vector2 spawnBlockIndex;
  final Blocks block;

  ItemComponent({required this.spawnBlockIndex, required this.block});

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    anchor = Anchor.center;
    position =
        spawnBlockIndex * GameMethods.blockSize.x + GameMethods.blockSize / 2;
    sprite = GameMethods.getSpriteFromBlock(block);
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    size = GameMethods.blockSize * 0.6;
  }
}
