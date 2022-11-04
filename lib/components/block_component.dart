import 'package:flame/components.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/game_methods.dart';

class Blockcomponent extends SpriteComponent {
  final Blocks block;

  Blockcomponent({required this.block});

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    size = GameMethods.getBlockSize();
    sprite = await GameMethods.getSpriteFromBlock(block);
  }
}
