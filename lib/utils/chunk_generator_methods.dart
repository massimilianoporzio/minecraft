import 'package:flame/components.dart';
import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/constants.dart';

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

  static List<List<Blocks?>> generateChunk() {
    List<List<Blocks?>> chunk = generateNullChunck();

    //the 5th  y level grass
    //* uso asMap così ho l'indicedi ogni riga
    chunk.asMap().forEach((int riga, List<Blocks?> rigadiBlocks) {
      if (riga == 5) {
        rigadiBlocks.asMap().forEach((int colonna, Blocks? block) {
          chunk[riga][colonna] = Blocks.grass;
        });
      }
    });

    return chunk;
  }
}
