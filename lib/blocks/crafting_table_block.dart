import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/inventory.dart';

import '../resources/blocks.dart';

class CraftingTableBlock extends BlockComponent {
  CraftingTableBlock({required super.blockIndex, required super.chunkIndex})
      : super(block: Blocks.craftingTable);
  //*costruire una CraftingTable è costruire un BlcokCoponent che ha come block la craftingtable!

  //*riferimento:
  InventoryManager inventoryManager =
      GlobalGameReference.instance.mainGameRef.worldData.inventoryManager;

  //*EXTRA FUNCIONTALITIES
  //*SE CLICCO SU CRAFTING TABLE VOGLIO APRIRE CRAFTING TABLE
  @override
  bool onTapDown(TapDownInfo info) {
    print("CRAFTINGTABLE COMPONENT TAP DOWN");
    //* se non ho nulla selezionato
    if (inventoryManager
        .inventorySlots[inventoryManager.currentSelectedSlot.value].isEmpty) {
      //*apro la crafting invenroty
      GlobalGameReference.instance.mainGameRef.worldData.craftingManager
          .craftingInventoryIsOpen.value = true;
    } else {
      //*chiamo il solito metodo
      super.onTapDown(info); //*ROMPE IL
    }
    info.handled = true;
    return true;
  }
}
