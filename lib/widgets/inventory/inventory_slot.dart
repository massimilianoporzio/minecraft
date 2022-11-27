import 'package:flame/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:minecraft/global/inventory.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_background.dart';

import 'inventory_item_and_number.dart';

class InventorySlotWidget extends StatelessWidget {
  final SlotType slotType;
  final InventorySlot inventorySlot;
  const InventorySlotWidget(
      {super.key, required this.slotType, required this.inventorySlot});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InventorySlotBackgroundWidget(slotType: slotType),
        InventoryItemAndNumberWidget(
          inventorySlot: inventorySlot,
        )
      ],
    );
  }
}
