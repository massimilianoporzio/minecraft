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
      //player inventory logic
      if (stickRecipeForPlayerGrid.recipe.hasMatch(turnCraftingGridIntoAString(
          playerInventoryCraftingGrid, stickRecipeForPlayerGrid.keys))) {
        //* se la griglia matcha con la ricetta dello stick
        playerInventoryCraftingGrid.last.block =
            stickRecipeForPlayerGrid.product;
        playerInventoryCraftingGrid.last.count.value =
            stickRecipeForPlayerGrid.productCount;
        return true;
      }
    } else {
      //std grdi logic
      if (stickRecipeForStdGrid.recipe.hasMatch(turnCraftingGridIntoAString(
          standardCraftingGrid, stickRecipeForStdGrid.keys))) {
        //* se la griglia matcha con la ricetta dello stick
        standardCraftingGrid.last.block = stickRecipeForStdGrid.product;
        standardCraftingGrid.last.count.value =
            stickRecipeForStdGrid.productCount;
        return true;
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
}
