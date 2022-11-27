import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';

import 'package:minecraft/global/inventory.dart';
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
    return GestureDetector(
      onTap: () {
        if (slotType == SlotType.itemBar) {
          //*SELEZIONO SOLO DALLA BARRA NON DALLO STORAGE
          GlobalGameReference.instance.mainGameRef.worldData.inventoryManager
              .currentSelectedSlot.value = inventorySlot.index;
          // print("Selezionato lo slot con indice ${inventorySlot.index}");
        }
      },
      child: Stack(
        children: [
          InventorySlotBackgroundWidget(
            slotType: slotType,
            index: inventorySlot.index,
          ),
          InventoryItemAndNumberWidget(
            inventorySlot: inventorySlot,
          )
        ],
      ),
    );
  }
}
