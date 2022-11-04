import 'package:flame/components.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/game_methods.dart';

class Blockcomponent extends SpriteComponent {
  final Blocks block;
  final Vector2 blockIndex;

  Blockcomponent({
    required this.block,
    required this.blockIndex,
  });

  @override
  Future<void>? onLoad() async {
    super.onLoad();

    sprite = await GameMethods.getSpriteFromBlock(block);
  }

  //*called every time the screen resize
  @override
  void onGameResize(Vector2 newScreenSize) {
    super.onGameResize(newScreenSize);
    size = GameMethods.getBlockSize();
    position = Vector2(
        size.x * blockIndex.x, size.y * blockIndex.y); //* valore iniziale
  }
}
