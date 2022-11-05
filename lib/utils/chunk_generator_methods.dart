import 'dart:developer';
import 'dart:math';

import 'package:fast_noise/fast_noise.dart';
import 'package:flame/components.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/utils/typedefs.dart';

import '../resources/biomes.dart';

class ChunkGenerationMethods {
  static ChunkGenerationMethods get instance {
    return ChunkGenerationMethods();
  }

/* 
un chunk ha 25 rows and 16 columns

*/
  static List<Null> getNullRow() {
    return List.generate(chunkWidth, (index) => null); //[row di null]
  }

  static List<List<Blocks?>> generateNullChunck() {
    return List.generate(
      chunkHeight,
      (index) => List.generate(chunkWidth, (index) => null),
    );
  }

  //*convert list of noise and returns list of Y coord
  static List<int> getYValuesFromRawNoise(List<List<double>> rawNoise) {
    List<int> yValues = [];
    rawNoise.asMap().forEach((int index, List<double> value) {
      yValues.add((value[0] * 10).toInt().abs() + GameMethods.freeArea);
    });
    return yValues;
  }

  static Chunck generateChunk() {
    //A CASO
    Biomes biome = Random().nextBool() ? Biomes.desert : Biomes.birchForest;

    Chunck chunk = generateNullChunck();

    //* NOISE per generare random chunk!
    List<List<double>> rawNoise = noise2(chunkWidth, 1,
        noiseType: NoiseType.Perlin,
        seed: 98765493,
        frequency: 0.05); //* uso 1 per dire una sola riga! la funz è 2D

    List<int> yValues = getYValuesFromRawNoise(rawNoise);

    chunk = generatePrimarySoil(chunk, yValues, biome);
    chunk = generateSecondarySoil(chunk, yValues, biome);
    chunk = generateStone(chunk);
    // //the 5th  y level grass
    // //* uso asMap così ho l'indicedi ogni riga
    // chunk.asMap().forEach((int riga, List<Blocks?> rigadiBlocks) {
    //   if (riga == 5) {
    //     rigadiBlocks.asMap().forEach((int colonna, Blocks? block) {
    //       chunk[riga][colonna] = Blocks.grass;
    //     });
    //   }
    //   if (riga >= 6) {
    //     rigadiBlocks.asMap().forEach((int colonna, Blocks? block) {
    //       chunk[riga][colonna] = Blocks.dirt;
    //     });
    //   }
    // });

    return chunk;
  }

  //* BORDO INIZIALE DEL TERRENO
  static Chunck generatePrimarySoil(
      Chunck chunk, List<int> yValues, Biomes biome) {
    Blocks block = BiomeData.fromBiome(biome).primarySoil;
    yValues.asMap().forEach((int index, value) {
      chunk[value][index] = block;
    });
    return chunk;
  }

//* BLOCCHI SOTTO IL TERRENO INIZIALE (6 in giù)
  static Chunck generateSecondarySoil(
      Chunck chunk, List<int> yValues, Biomes biome) {
    Blocks block = BiomeData.fromBiome(biome).primarySoil;
    yValues.asMap().forEach((int index, value) {
      for (var i = value + 1; i <= GameMethods.maxSecondarySoilExtent; i++) {
        chunk[i][index] = block;
      }
    });
    return chunk;
  }

  static Chunck generateStone(Chunck chunck) {
    //* DA ALMENO 1 sotto il primo sotto il terrno
    //*iterate over x
    for (var index = 0; index < chunkWidth; index++) {
      //*itero in Y scendo
      for (var i = GameMethods.maxSecondarySoilExtent + 1;
          i < chunck.length;
          i++) {
        chunck[i][index] = Blocks.stone;
      }
    }

    //*RANDOM STONE CHE SPUNTANO
    int x1 = Random().nextInt(chunkWidth ~/ 2); //*divisione intera
    int x2 = x1 + Random().nextInt(chunkWidth ~/ 2); //*seconda metà

    chunck[GameMethods.maxSecondarySoilExtent].fillRange(x1, x2, Blocks.stone);
    return chunck;
  }
}
