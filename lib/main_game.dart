import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/world_data.dart';

class MainGame extends FlameGame {
  final WorldData worldData; //*riceve i dati del mondo da un launcher

  MainGame({required this.worldData});
  //*SIAMO NEL MAIN, il componente "root"
  //qui creo una istanza e la metto a disposizione di tutti i componenti (getX)
  GlobalGameReference globalGameReference = GlobalGameReference.instance;

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    add(PlayerComponent());
  }
}
