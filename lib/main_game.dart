import 'package:flame/game.dart';
import 'package:get/get.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/components/player_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/chunk_generator_methods.dart';
import 'package:minecraft/utils/game_methods.dart';

class MainGame extends FlameGame {
  final WorldData worldData; //*riceve i dati del mondo da un launcher

  MainGame({required this.worldData}) {
    //*quando creo un MainGame assegno l'istanza creata al field mainRef del global instance
    globalGameReference.mainGameRef = this;
  }
  //*SIAMO NEL MAIN, il componente "root"
  //qui creo una istanza e la metto a disposizione di tutti i componenti (getX)
  GlobalGameReference globalGameReference = Get.put(GlobalGameReference());

  PlayerComponent playerComponent = PlayerComponent();
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    camera.followComponent(playerComponent);
    GameMethods.addChunckToRightWorldChunks(
        ChunkGenerationMethods.generateChunk(0)); //chunck centrale
    GameMethods.addChunckToRightWorldChunks(
        ChunkGenerationMethods.generateChunk(1)); // chunck destro
    GameMethods.addChunckToRightWorldChunks(
        ChunkGenerationMethods.generateChunk(2)); // chunck destro
    renderChunk();
    // renderChunk(ChunkGenerationMethods.generateChunk());

    add(playerComponent);
  }

  void renderChunk() {
    //iterate over rightWorldChunk

    worldData.rightWorldChunk
        .asMap()
        .forEach((int yIndex, List<Blocks?> rowOfBlocks) {
      rowOfBlocks.asMap().forEach((int xIndex, Blocks? block) {
        if (block != null) {
          add(Blockcomponent(
              block: block,
              blockIndex: Vector2(xIndex.toDouble(), yIndex.toDouble())));
        }
      });
    });
  }
}
