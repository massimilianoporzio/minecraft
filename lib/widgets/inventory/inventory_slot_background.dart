import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';

class InventorySlotBackgroundWidget extends StatelessWidget {
  final SlotType slotType;
  final int index;
  const InventorySlotBackgroundWidget(
      {super.key, required this.slotType, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: GameMethods.slotSize,
        height: GameMethods.slotSize,
        child: FittedBox(
            child: Obx(() => index ==
                        GlobalGameReference.instance.mainGameRef.worldData
                            .inventoryManager.currentSelectedSlot.value &&
                    slotType == SlotType.itemBar
                ? Image.asset(
                    "assets/images/inventory/inventory_active_slot.png")
                : Image.asset(getPath(slotType)))));
  }

  String getPath(SlotType slotType) {
    switch (slotType) {
      case SlotType.inventory:
        return "assets/images/inventory/inventory_item_storage_slot.png";
      case SlotType.itemBar:
        return "assets/images/inventory/inventory_item_bar_slot.png";
      case SlotType.crafting:
        return "assets/images/inventory/inventory_item_storage_slot.png";
      case SlotType.craftingOutput:
        return "assets/images/inventory/inventory_item_storage_slot.png";
      default:
        return "assets/images/inventory/inventory_item_storage_slot.png";
    }
  }
}
