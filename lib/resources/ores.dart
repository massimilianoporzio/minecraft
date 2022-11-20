import 'package:minecraft/resources/bloks.dart';

class Ore {
  final Blocks block;
  final int rarity;

  Ore({required this.block, required this.rarity});
  static Ore ironOre = Ore(block: Blocks.ironOre, rarity: 80);
  static Ore coalOre = Ore(block: Blocks.coalOre, rarity: 90);
  static Ore goldOre = Ore(block: Blocks.goldOre, rarity: 60);
  static Ore diamondOre = Ore(block: Blocks.diamondOre, rarity: 55);
  static Ore lolliteOre = Ore(block: Blocks.lollite, rarity: 54);
}

List Ores = [Blocks.coalOre, Blocks.goldOre, Blocks.ironOre, Blocks.diamondOre];
