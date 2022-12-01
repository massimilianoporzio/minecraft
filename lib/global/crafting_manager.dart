import 'package:minecraft/global/inventory.dart';

class CraftingManager {
  List<InventorySlot> playerInventoryCraftingGrid = List.generate(
      5, (index) => InventorySlot(index: index)); //* 4 (2x2) e 1 output
}
