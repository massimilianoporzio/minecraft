import 'package:minecraft/resources/bloks.dart';
import 'package:minecraft/utils/typedefs.dart';

class Structure {
  final Chunk structure; //* è una lista di lista di blocchi come i chunk
  final int maxOccurences; //* num max di structure in un chunk
  final int maxWidth; //* quanto è larga al massimo una structure

  Structure(
      {required this.structure,
      required this.maxOccurences,
      required this.maxWidth});
}

//*PROVIAMO UN ALBERO

Structure treeStructure = Structure(structure: [
  [
    Blocks.birchLeaf,
    Blocks.birchLeaf,
    Blocks.birchLeaf,
  ],
  [
    Blocks.birchLeaf,
    Blocks.birchLeaf,
    Blocks.birchLeaf,
  ],
  [
    Blocks.birchLeaf,
    Blocks.birchLeaf,
    Blocks.birchLeaf,
  ],
  [null, Blocks.birchLog, null],
  [null, Blocks.birchLog, null],
], maxOccurences: 1, maxWidth: 3);
