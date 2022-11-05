import 'package:minecraft/resources/bloks.dart';

enum Biomes { desert, birchForest }

class BiomeData {
  final Blocks primarySoil;
  final Blocks secondarySoil;

  BiomeData({required this.primarySoil, required this.secondarySoil});

  factory BiomeData.fromBiome(Biomes biome) {
    switch (biome) {
      case Biomes.desert:
        return BiomeData(primarySoil: Blocks.sand, secondarySoil: Blocks.sand);
      case Biomes.birchForest:
        return BiomeData(primarySoil: Blocks.grass, secondarySoil: Blocks.dirt);
    }
  }
}
