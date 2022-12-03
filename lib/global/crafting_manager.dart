import 'package:get/get.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/inventory.dart';
import 'package:minecraft/utils/typedefs.dart';

import '../resources/blocks.dart';
import '../resources/items.dart';

class CraftingManager {
  Rx<bool> craftingInventoryIsOpen = false.obs; //*osservabile ora!

  CraftingGrid playerInventoryCraftingGrid = List.generate(
      5, (index) => InventorySlot(index: index)); //* 4 (2x2) e 1 output

  CraftingGrid standardCraftingGrid = List.generate(
      10, (index) => InventorySlot(index: index)); //* 9 (3x3) e 1 output

  static bool isInPlayerInventory() {
    return GlobalGameReference
        .instance.mainGameRef.worldData.inventoryManager.inventoryIsOpen.value;
  }

  Recipe stickRecipeForStdGrid = Recipe(
      recipe: RegExp(
          "^E*WEEWE*\$"), //*dal primo carattere ^ fino all'ultimo \$ cerca se sono tutti vuoti tranne una cosa come WEEW
      product: Items.stick,
      productCount: 4,
      keys: {Items.apple: "W"});

  Recipe stickRecipeForPlayerGrid = Recipe(
      recipe: RegExp(
          "^E*WEWE*\$"), //*dal primo carattere ^ fino all'ultimo \$ cerca se sono tutti vuoti tranne una cosa come WEW
      product: Items.stick,
      productCount: 4,
      keys: {Items.apple: "W"});

  bool checkForRecipe() {
    if (isInPlayerInventory()) {
      //player inventory logicù
      //*giro le ricette
      for (var index = 0;
          index < Recipe.playerInventoryGridRecipe.length;
          index++) {
        Recipe recipe = Recipe.playerInventoryGridRecipe[index];
        if (recipe.recipe.hasMatch(turnCraftingGridIntoAString(
            playerInventoryCraftingGrid, recipe.keys))) {
          //MATCH"
          playerInventoryCraftingGrid.last.block = recipe.product;
          playerInventoryCraftingGrid.last.count.value = recipe.productCount;
          return true; //*ESCO DAL LOOP ALLA PRIMA RICETTA CON MATCH
        }
      }
    } else {
      //std grdi logic
      //*giro le ricette
      for (var index = 0; index < Recipe.standardGridRecipe.length; index++) {
        Recipe recipe = Recipe.standardGridRecipe[index];
        if (recipe.recipe.hasMatch(
            turnCraftingGridIntoAString(standardCraftingGrid, recipe.keys))) {
          //MATCH"
          standardCraftingGrid.last.block = recipe.product;
          standardCraftingGrid.last.count.value = recipe.productCount;
          return true; //*ESCO DAL LOOP ALLA PRIMA RICETTA CON MATCH
        }
      }
    }
    //*NO MATCHES
    standardCraftingGrid.last.emptySlot();
    playerInventoryCraftingGrid.last.emptySlot();
    return false; //*default
  }

  void decrementOneFromEachSlot(CraftingGrid grid) {
    grid.asMap().forEach((int index, InventorySlot slot) {
      if (!slot.isEmpty) {
        slot.decrementSlot();
      }
    });
  }

  String turnCraftingGridIntoAString(CraftingGrid craftingGrid, Map keys) {
    List gridString = [];
    craftingGrid.asMap().forEach((int index, InventorySlot slot) {
      if (slot.isEmpty) {
        gridString.add("E");
      } else if (keys.containsKey(slot.block)) {
        //*se tra le chiavi ho il blocco che è nello slot
        gridString.add(keys[slot.block]);
      }
    });
    return gridString.join();
  }
}

class Recipe {
  final RegExp recipe;
  final dynamic product;
  final int productCount;
  final Map keys; //* {Blocks.birchPlants : "W", ecc}ù
  Recipe(
      {required this.recipe,
      required this.product,
      required this.productCount,
      required this.keys});

  static List<Recipe> playerInventoryGridRecipe = [
    //dead bush stick
    Recipe(
        recipe: RegExp("^E*SE*\$"),
        keys: {Blocks.deadBush: "S"},
        product: Items.stick,
        productCount: 1),

    //stick
    Recipe(
        recipe: RegExp("^E*WEWE*\$"),
        product: Items.stick,
        productCount: 4,
        keys: {Blocks.birchPlank: "W"}),

    //birch planks
    Recipe(
        recipe: RegExp("^E*WE*\$"),
        keys: {Blocks.birchLog: "W"},
        product: Blocks.birchPlank,
        productCount: 4),

    //crafting table
    Recipe(
        recipe: RegExp("^E*BBBBE*\$"),
        keys: {Blocks.birchPlank: "B"},
        product: Blocks.craftingTable,
        productCount: 1),
  ];

  static List standardGridRecipe = [
    //dead bush stick
    Recipe(
        recipe: RegExp("^E*SE*\$"),
        keys: {Blocks.deadBush: "S"},
        product: Items.stick,
        productCount: 1),

    // //stick for standardGrid
    // Recipe(
    //     recipe: RegExp("^E*WEEWE*\$"),
    //     keys: {Blocks.birchPlank: "W"},
    //     product: Items.stick,
    //     productCount: 4),

    //birch planks
    Recipe(
        recipe: RegExp("^E*WE*\$"),
        keys: {Blocks.birchLog: "W"},
        product: Blocks.birchPlank,
        productCount: 4),

    //crafting table
    Recipe(
        recipe: RegExp("^E*BBEBBEE*\$"),
        keys: {Blocks.birchPlank: "B"},
        product: Blocks.craftingTable,
        productCount: 1),

    //wooden sword
    Recipe(
        recipe: RegExp("^E*WEEWEESE*\$"),
        keys: {Blocks.birchPlank: "W", Items.stick: "S"},
        product: Items.woodenSword,
        productCount: 1),

    //wooden shovel
    Recipe(
        recipe: RegExp("^E*WEESEESE*\$"),
        keys: {Blocks.birchPlank: "W", Items.stick: "S"},
        product: Items.woodenShovel,
        productCount: 1),

    //wooden pickaxe
    Recipe(
        recipe: RegExp("WWWESEESE"),
        keys: {Blocks.birchPlank: "W", Items.stick: "S"},
        product: Items.woodenPickaxe,
        productCount: 1),

    //wooden axe
    Recipe(
        recipe: RegExp("^E*WWESWESE*\$"),
        keys: {Blocks.birchPlank: "W", Items.stick: "S"},
        product: Items.woodenAxe,
        productCount: 1),

    //Stone sword
    Recipe(
        recipe: RegExp("^E*CEECEESE*\$"),
        keys: {Blocks.cobblestone: "C", Items.stick: "S"},
        product: Items.stoneSword,
        productCount: 1),

    //stone shovel
    Recipe(
        recipe: RegExp("^E*CEESEESE*\$"),
        keys: {Blocks.cobblestone: "C", Items.stick: "S"},
        product: Items.stoneShovel,
        productCount: 1),

    //stone pickaxe
    Recipe(
        recipe: RegExp("CCCESEESE"),
        keys: {Blocks.cobblestone: "C", Items.stick: "S"},
        product: Items.stonePickaxe,
        productCount: 1),

    //stone axe
    Recipe(
        recipe: RegExp("^E*CCESCESE*\$"),
        keys: {Blocks.cobblestone: "C", Items.stick: "S"},
        product: Items.stoneAxe,
        productCount: 1),

    //iron sword
    Recipe(
        recipe: RegExp("^E*IEEIEESE*\$"),
        keys: {Items.ironIngot: "I", Items.stick: "S"},
        product: Items.ironSword,
        productCount: 1),

    //iron shovel
    Recipe(
        recipe: RegExp("^E*IEESEESE*\$"),
        keys: {Items.ironIngot: "I", Items.stick: "S"},
        product: Items.ironShovel,
        productCount: 1),

    //iron pickaxe
    Recipe(
        recipe: RegExp("IIIESEESE"),
        keys: {Items.ironIngot: "I", Items.stick: "S"},
        product: Items.ironPickaxe,
        productCount: 1),

    //iron axe
    Recipe(
        recipe: RegExp("^E*IIESIESE*\$"),
        keys: {Items.ironIngot: "I", Items.stick: "S"},
        product: Items.ironAxe,
        productCount: 1),

    //gold sword
    Recipe(
        recipe: RegExp("^E*GEEGEESE*\$"),
        keys: {Items.goldIngot: "G", Items.stick: "S"},
        product: Items.goldenSword,
        productCount: 1),

    //gold shovel
    Recipe(
        recipe: RegExp("^E*GEESEESE*\$"),
        keys: {Items.goldIngot: "G", Items.stick: "S"},
        product: Items.goldenShovel,
        productCount: 1),

    //gold pickaxe
    Recipe(
        recipe: RegExp("GGGESEESE"),
        keys: {Items.goldIngot: "G", Items.stick: "S"},
        product: Items.goldenPickaxe,
        productCount: 1),

    //gold axe
    Recipe(
        recipe: RegExp("^E*GGESGESE*\$"),
        keys: {Items.goldIngot: "G", Items.stick: "S"},
        product: Items.goldenAxe,
        productCount: 1),

    //diamond sword
    Recipe(
        recipe: RegExp("^E*DEEDEESE*\$"),
        keys: {Items.diamond: "D", Items.stick: "S"},
        product: Items.diamondSword,
        productCount: 1),

    //diamond shovel
    Recipe(
        recipe: RegExp("^E*DEESEESE*\$"),
        keys: {Items.diamond: "D", Items.stick: "S"},
        product: Items.diamondShovel,
        productCount: 1),

    //diamond pickaxe
    Recipe(
        recipe: RegExp("DDDESEESE"),
        keys: {Items.diamondAxe: "D", Items.stick: "S"},
        product: Items.diamondPickaxe,
        productCount: 1),

    //diamond axe
    Recipe(
        recipe: RegExp("^E*DDESDESE*\$"),
        keys: {Items.diamond: "D", Items.stick: "S"},
        product: Items.diamondAxe,
        productCount: 1),
    //lollite sword
    Recipe(
        recipe: RegExp("^E*LEELEESE*\$"),
        keys: {Items.lolliteIngot: "L", Items.stick: "S"},
        product: Items.lolliteSword,
        productCount: 1),
//lollite pickaxe
    Recipe(
        recipe: RegExp("LLLESEESE"),
        keys: {Items.lolliteIngot: "L", Items.stick: "S"},
        product: Items.lollitePickaxe,
        productCount: 1),
    //lollite shovel
    Recipe(
        recipe: RegExp("^E*LEESEESE*\$"),
        keys: {Items.lolliteIngot: "L", Items.stick: "S"},
        product: Items.lolliteShovel,
        productCount: 1),
    //lollite axe
    Recipe(
        recipe: RegExp("^E*LLESLESE*\$"),
        keys: {Items.lolliteIngot: "L", Items.stick: "S"},
        product: Items.lolliteAxe,
        productCount: 1),

    Recipe(
        recipe: RegExp("CCCCECCCC"),
        keys: {Blocks.cobblestone: "C"},
        product: Blocks.furnace,
        productCount: 1),
  ];
}
