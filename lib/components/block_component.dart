import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/game_methods.dart';

class Blockcomponent extends SpriteComponent {
  final Blocks block;
  final Vector2 blockIndex;
  final int chunkIndex; //* di che chunk fa parte

  Blockcomponent(
      {required this.block,
      required this.blockIndex,
      required this.chunkIndex});

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    add(RectangleHitbox()); //*collisioni
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

//*CHECK SE INDEX DEL CHUNK è DA RENDER SE NO LO RIMUOVO
  @override
  void update(double dt) {
    super.update(dt);
    if (!GlobalGameReference
        .instance.mainGameRef.worldData.chunksThathShoudlBeRendered
        .contains(chunkIndex)) {
      //*UNRENDERING
      removeFromParent();
      GlobalGameReference.instance.mainGameRef.worldData.currentlyRenderedChunks
          .remove(chunkIndex); //*lo "notifico" che non è più render
    }
  }
}
