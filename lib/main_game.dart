import 'package:flame/game.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/world_data.dart';

class MainGame extends FlameGame {
  final WorldData worldData; //*riceve i dati del mondo da un launcher

  MainGame({required this.worldData});

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    add(PlayerComponent());
  }
}
