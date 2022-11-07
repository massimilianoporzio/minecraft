import 'package:minecraft/resources/bloks.dart';

class Ore {
  final Blocks block;
  final int rarity;

  Ore({required this.block, required this.rarity});
  static Ore ironOre = Ore(block: Blocks.ironOre, rarity: 110);
  static Ore coalOre = Ore(block: Blocks.coalOre, rarity: 110);
  static Ore goldOre = Ore(block: Blocks.goldOre, rarity: 74);
  static Ore diamondOre = Ore(block: Blocks.diamondOre, rarity: 60);
}
