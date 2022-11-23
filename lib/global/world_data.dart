import 'package:minecraft/components/item_component.dart';
import 'package:minecraft/global/inventory.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../utils/typedefs.dart';

class WorldData {
  final int seed; //* generazione random

  //*data for a World!
  //*ogni mondo ha dati del player PROPRI!
  PlayerData playerData = PlayerData();

  //RIGHT CHUNK LIST lista degli indici più grandi di 0
  //rendere sempre i chunk che stanno -1 0 1 nella lista
  Chunk rightWorldChunk = List.generate(
    chunkHeight,
    (index) => [],
  );
  Chunk leftWorldChunk = List.generate(
    chunkHeight,
    (index) => [],
  );

  WorldData({required this.seed}); //per ora così

  List<int> get chunksThathShoudlBeRendered {
    return [
      GameMethods.currentChunk - 1,
      GameMethods.currentChunk,
      GameMethods.currentChunk + 1
    ];
  }

  List<int> currentlyRenderedChunks = [];
  List<ItemComponent> items = [];

  InventoryManager inventoryManager = InventoryManager(); //GLOBALE
}
