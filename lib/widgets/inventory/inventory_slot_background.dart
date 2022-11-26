import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';

class InventorySlotBackgroundWidget extends StatelessWidget {
  final SlotType slotType;
  const InventorySlotBackgroundWidget({super.key, required this.slotType});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: GameMethods.slotSize,
        height: GameMethods.slotSize,
        child: FittedBox(child: Image.asset(getPath(slotType))));
  }

  String getPath(SlotType slotType) {
    switch (slotType) {
      case SlotType.inventory:
        return "assets/images/inventory/inventory_item_storage_slot.png";
      case SlotType.itemBar:
        return "assets/images/inventory/inventory_item_bar_slot.png";
      default:
        return "assets/images/inventory/inventory_item_storage_slot.png";
    }
  }
}
