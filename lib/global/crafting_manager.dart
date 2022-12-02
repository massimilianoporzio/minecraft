import 'package:get/get.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/inventory.dart';

class CraftingManager {
  Rx<bool> craftingInventoryIsOpen = false.obs; //*osservabile ora!

  List<InventorySlot> playerInventoryCraftingGrid = List.generate(
      5, (index) => InventorySlot(index: index)); //* 4 (2x2) e 1 output

  List<InventorySlot> standardCraftingGrid = List.generate(
      10, (index) => InventorySlot(index: index)); //* 9 (3x3) e 1 output

  static bool isInPlayerInventory() {
    return GlobalGameReference
        .instance.mainGameRef.worldData.inventoryManager.inventoryIsOpen.value;
  }
}
