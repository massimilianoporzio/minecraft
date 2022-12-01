import 'package:flame/components.dart';
import 'package:minecraft/blocks/crafting_table_block.dart';
import 'package:minecraft/components/block_component.dart';

enum Blocks {
  grass,
  dirt,
  stone,
  birchLog,
  birchLeaf,
  cactus,
  deadBush,
  sand,
  coalOre,
  ironOre,
  diamondOre,
  goldOre,
  grassPlant,
  redFlower,
  purpleFlower,
  drippingWhiteFlower,
  yellowFlower,
  whiteFlower,
  birchPlank,
  craftingTable,
  cobblestone,
  bedrock,
  lollite
}
//* SONO NELL'ORDINE IN CUI LI TROVO NELLO SPRITESHEET!

List Piante = [
  Blocks.deadBush,
  Blocks.redFlower,
  Blocks.whiteFlower,
  Blocks.purpleFlower,
  Blocks.yellowFlower,
  Blocks.drippingWhiteFlower
];

class BlockData {
  final bool isCollidable;
  final double baseMiningSpeed;
  final bool breakable;

  static BlockData plant =
      BlockData(isCollidable: false, baseMiningSpeed: 0.00001);
  static BlockData soil = BlockData(isCollidable: true, baseMiningSpeed: 0.75);
  static BlockData wood = BlockData(isCollidable: false, baseMiningSpeed: 3);
  static BlockData leaf = BlockData(isCollidable: false, baseMiningSpeed: 0.35);
  static BlockData stone = BlockData(isCollidable: true, baseMiningSpeed: 1);
  static BlockData woodPlank =
      BlockData(isCollidable: true, baseMiningSpeed: 2.5);
  static BlockData unbreakable =
      BlockData(isCollidable: true, baseMiningSpeed: 1, breakable: false);

  BlockData(
      {this.breakable = true, //*tranne per l'ultima riga
      required this.isCollidable,
      required this.baseMiningSpeed});

  factory BlockData.getBlockDataFor(Blocks block) {
    switch (block) {
      case Blocks.dirt:
        return BlockData.soil;

      case Blocks.grass:
        return BlockData.soil;

      case Blocks.birchLeaf:
        return BlockData.leaf;

      case Blocks.birchLog:
        return BlockData.wood;

      case Blocks.cactus:
        return BlockData.plant;

      case Blocks.coalOre:
        return BlockData.stone;

      case Blocks.deadBush:
        return BlockData.plant;

      case Blocks.ironOre:
        return BlockData.stone;

      case Blocks.sand:
        return BlockData.soil;

      case Blocks.stone:
        return BlockData.stone;

      case Blocks.grassPlant:
        return BlockData.plant;

      case Blocks.redFlower:
        return BlockData.plant;

      case Blocks.purpleFlower:
        return BlockData.plant;

      case Blocks.drippingWhiteFlower:
        return BlockData.plant;

      case Blocks.yellowFlower:
        return BlockData.plant;

      case Blocks.whiteFlower:
        return BlockData.plant;

      case Blocks.diamondOre:
        return BlockData.stone;

      case Blocks.goldOre:
        return BlockData.stone;

      case Blocks.birchPlank:
        return BlockData.woodPlank;

      case Blocks.craftingTable:
        return BlockData.woodPlank;

      case Blocks.cobblestone:
        return BlockData.stone;

      case Blocks.bedrock:
        return BlockData.unbreakable;

      case Blocks.lollite:
        return BlockData.stone;
    }
  }

  static BlockComponent getParentForBlock(
      Blocks block, Vector2 blockIndex, int chunkIndex) {
    switch (block) {
      case Blocks.craftingTable:
        //*GESTISCO CRAFTINGTABLE
        return CraftingTableBlock(
            blockIndex: blockIndex, chunkIndex: chunkIndex);

      default:
        //*GESTISCO GLI ALTRI CASI
        return BlockComponent(
            block: block, blockIndex: blockIndex, chunkIndex: chunkIndex);
    }
  }
}
