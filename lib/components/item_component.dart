import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/resources/entity.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../resources/blocks.dart';
import 'block_component.dart';

class ItemComponent extends Entity {
  final Vector2 spawnBlockIndex;
  final Blocks block;

  ItemComponent({required this.spawnBlockIndex, required this.block});

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    //*HitBox per le collisioni
    add(RectangleHitbox());
    anchor = Anchor.center;
    position =
        spawnBlockIndex * GameMethods.blockSize.x + GameMethods.blockSize / 2;
    //*animazione con UN SOLO SPRITE
    animation = SpriteAnimation.spriteList(
        [GameMethods.getSpriteFromBlock(block)],
        stepTime: 1);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BlockComponent &&
        BlockData.getBlockDataFor(other.block).isCollidable) {
      //*chima la collisione su Entity ma solo se era isCollidable il blocco
      super.onCollision(intersectionPoints, other);
    } else if (other is PlayerComponent) {
      //*il giocatore ci è passato sopra: lo agg all'inventario
      print("Add $block to inventory");
      removeFromParent();
    }
  }

  @override
  void onGameResize(Vector2 newSize) {
    super.onGameResize(newSize);
    size = GameMethods.blockSize * 0.6;
  }

  @override
  void update(double dt) {
    super.update(dt);
    fallingLogic(dt);
  }
}
