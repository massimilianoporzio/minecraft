import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot.dart';

class ItemBarWidget extends StatelessWidget {
  const ItemBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.only(bottom: GameMethods.slotSize / 7),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          InventorySlotWidget(
              slotType: SlotType.itemBar,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[0]),
          InventorySlotWidget(
              slotType: SlotType.itemBar,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[1]),
          InventorySlotWidget(
              slotType: SlotType.itemBar,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[2]),
          InventorySlotWidget(
              slotType: SlotType.itemBar,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[3]),
          InventorySlotWidget(
              slotType: SlotType.itemBar,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[4]),
          InventorySlotWidget(
              slotType: SlotType.itemBar,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[5]),
          InventorySlotWidget(
              slotType: SlotType.itemBar,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[6]),
          InventorySlotWidget(
              slotType: SlotType.itemBar,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[7]),
          InventorySlotWidget(
              slotType: SlotType.itemBar,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[8]),
        ]),
      ),
    );
  }
}
