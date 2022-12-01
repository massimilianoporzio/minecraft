import 'package:flutter/material.dart';

import '../../global/global_game_reference.dart';
import '../../utils/game_methods.dart';
import '../inventory/inventory_slot.dart';

class StandardCraftingGridWidget extends StatelessWidget {
  const StandardCraftingGridWidget({super.key});

  Column getStandardCraftingGrid() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.standardCraftingGrid[0]),
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.standardCraftingGrid[1]),
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.standardCraftingGrid[2]),
          ],
        ),
        //*seconda riga
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.standardCraftingGrid[3]),
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.standardCraftingGrid[4]),
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.standardCraftingGrid[5]),
          ],
        ),
        //*Terza riga
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.standardCraftingGrid[6]),
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.standardCraftingGrid[7]),
            InventorySlotWidget(
                slotType: SlotType.inventory,
                inventorySlot: GlobalGameReference.instance.mainGameRef
                    .worldData.craftingManager.standardCraftingGrid[8]),
          ],
        )
      ],
    );
  }

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
                  getStandardCraftingGrid(),
                  SizedBox(
                      height: (GameMethods.slotSize * 9.5) / 8,
                      child: Image.asset(
                          "assets/images/inventory/inventory_arrow.png")),
                  InventorySlotWidget(
                      slotType: SlotType.inventory,
                      inventorySlot: GlobalGameReference.instance.mainGameRef
                          .worldData.craftingManager.standardCraftingGrid[9])
                ]),
          ),
        ),
      ),
    );
  }
}
