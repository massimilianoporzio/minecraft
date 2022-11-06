import 'dart:developer';
import 'dart:math' as math;

import 'package:fast_noise/fast_noise.dart';
import 'package:flame/components.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/resources/structures.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/utils/typedefs.dart';

import '../resources/biomes.dart';
import '../structures/trees.dart';

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

  static Chunk generateChunk(int chunckIndex) {
    //A CASO
    Biomes biome =
        math.Random().nextBool() ? Biomes.desert : Biomes.birchForest;
    int seed = GlobalGameReference.instance.mainGameRef.worldData.seed;
    seed += chunckIndex < 0 ? 10 : 0;
    Chunk chunk = generateNullChunck();

    //* NOISE per generare random chunk! creo noise anche per n chunk
    //* uso abs per i left (indici negativi) e non aggiungo 1 perché sto a sinistra
    int indice = chunckIndex >= 0
        ? chunkWidth * (chunckIndex + 1)
        : chunkWidth * (chunckIndex.abs());

    List<List<double>> rawNoise = noise2(
        indice, 1, //* +1 e per partire dalla prima chunckWidth:16, 32 ecc.
        noiseType: NoiseType.Perlin,
        seed: seed,
        frequency: 0.05); //* uso 1 per dire una sola riga! la funz è 2D

    List<int> yValues = getYValuesFromRawNoise(rawNoise);
    //*ora però mi servono solo gli ultimi 16 valori (DESTRA)

    yValues.removeRange(
        0,
        chunckIndex >= 0
            ? chunkWidth * chunckIndex
            : chunkWidth * (chunckIndex.abs() - 1));

    chunk = generatePrimarySoil(chunk, yValues, biome);
    chunk = generateSecondarySoil(chunk, yValues, biome);
    chunk = generateStone(chunk);
    chunk = addStructureToChunk(chunk, yValues, biome);
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
  static Chunk generatePrimarySoil(
      Chunk chunk, List<int> yValues, Biomes biome) {
    Blocks block = BiomeData.fromBiome(biome).primarySoil;
    yValues.asMap().forEach((int index, value) {
      chunk[value][index] = block;
    });
    return chunk;
  }

//* BLOCCHI SOTTO IL TERRENO INIZIALE (6 in giù)
  static Chunk generateSecondarySoil(
      Chunk chunk, List<int> yValues, Biomes biome) {
    Blocks block = BiomeData.fromBiome(biome).primarySoil;
    yValues.asMap().forEach((int index, value) {
      for (var i = value + 1; i <= GameMethods.maxSecondarySoilExtent; i++) {
        chunk[i][index] = block;
      }
    });
    return chunk;
  }

  static Chunk generateStone(Chunk chunck) {
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
    int x1 = math.Random().nextInt(chunkWidth ~/ 2); //*divisione intera
    int x2 = x1 + math.Random().nextInt(chunkWidth ~/ 2); //*seconda metà

    chunck[GameMethods.maxSecondarySoilExtent].fillRange(x1, x2, Blocks.stone);
    return chunck;
  }

//*STRUTTURE
  static Chunk addStructureToChunk(
      Chunk chunk, List<int> yValues, Biomes biome) {
    //*la voglio aggiungere DENTRO il chunk non che sbordi su altri chunk
    BiomeData.fromBiome(biome)
        .generatingStructures
        .asMap()
        .forEach((key, Structure currentStructure) {
      int numOcc = math.Random().nextInt(currentStructure.maxOccurences);
      if (numOcc == 0 || numOcc == 1) {
        numOcc = 2;
      }

      for (var occ = 0; occ < numOcc; occ++) {
        Chunk structureList = List.from(currentStructure.structure
            .reversed); //*creo copia al contrario (disegno al contrario)
        final int xPos =
            math.Random().nextInt(chunkWidth - currentStructure.maxWidth);
        final int yPos = (yValues[xPos + (currentStructure.maxWidth ~/ 2)]) -
            1; //* il corrispo yValue del terreno ma relativo al centro della struttura
        //*itero sulle righe della struttura e tiro su di 1

        for (var indexOfRow = 0;
            indexOfRow < currentStructure.structure.length;
            indexOfRow++) {
          List<Blocks?> rigadiBlocksInStructure = structureList[indexOfRow];
          rigadiBlocksInStructure
              .asMap()
              .forEach((int index, Blocks? blockInStructure) {
            if (chunk[yPos - indexOfRow][xPos + index] == null) {
              chunk[yPos - indexOfRow][xPos + index] = blockInStructure;
            }
          });
        }
      }
    });

    return chunk;
  }
}
