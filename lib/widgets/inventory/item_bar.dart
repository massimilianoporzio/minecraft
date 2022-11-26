import 'package:flutter/material.dart';
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
          InventorySlotWidget(slotType: SlotType.itemBar),
          InventorySlotWidget(slotType: SlotType.itemBar),
          InventorySlotWidget(slotType: SlotType.itemBar),
          InventorySlotWidget(slotType: SlotType.itemBar),
          InventorySlotWidget(slotType: SlotType.itemBar),
          InventorySlotWidget(slotType: SlotType.itemBar),
          InventorySlotWidget(slotType: SlotType.itemBar),
          InventorySlotWidget(slotType: SlotType.itemBar),
          InventorySlotWidget(slotType: SlotType.itemBar),
        ]),
      ),
    );
  }
}
