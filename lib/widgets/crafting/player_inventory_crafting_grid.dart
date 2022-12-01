import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot.dart';

class PlayerInventoryCraftingGridWidget extends StatelessWidget {
  const PlayerInventoryCraftingGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: GameMethods.slotSize * 0.5),
          child: SizedBox(
            height: GameMethods.slotSize * 4,
            width: GameMethods.slotSize * 10,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //*crafting grdi 4x4 a col of two rows
                  getPlayerCraftingGrid(),
                  SizedBox(
                      height: (GameMethods.slotSize * 9.5) / 8,
                      child: Image.asset(
                          "assets/images/inventory/inventory_arrow.png")),
                  InventorySlotWidget(
                      slotType: SlotType.inventory,
                      inventorySlot: GlobalGameReference
                          .instance
                          .mainGameRef
                          .worldData
                          .craftingManager
                          .playerInventoryCraftingGrid[4])
                ]),
          ),
        ),
      ),
    );
  }

  Column getPlayerCraftingGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.playerInventoryCraftingGrid[0]),
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.playerInventoryCraftingGrid[1]),
          ],
        ),
        //*seconda riga
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.playerInventoryCraftingGrid[2]),
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.playerInventoryCraftingGrid[3]),
          ],
        )
      ],
    );
  }
}
