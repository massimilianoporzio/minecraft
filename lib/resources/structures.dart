import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/typedefs.dart';

class Structure {
  final Chunk structure; //* è una lista di lista di blocchi come i chunk
  final int maxOccurences; //* num max di structure in un chunk
  final int maxWidth; //* quanto è larga al massimo una structure

  Structure(
      {required this.structure,
      required this.maxOccurences,
      required this.maxWidth});

  factory Structure.getPlantStructureForBlock(Blocks block) {
    return Structure(structure: [
      [block]
    ], maxOccurences: 1, maxWidth: 1);
  }
}
