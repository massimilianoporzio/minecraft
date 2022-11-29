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
    switch (slotType) {
      //*item bar
      case SlotType.itemBar:
      return  GestureDetector(
            //* child di Draggable è COSA voglio vedere quando NON STO SPOSTANDO
            onTap: () {
              //SOLO PER ITEMBAR
                //*SELEZIONO SOLO DALLA BARRA NON DALLO STORAGE
                GlobalGameReference
                    .instance
                    .mainGameRef
                    .worldData
                    .inventoryManager
                    .currentSelectedSlot
                    .value = inventorySlot.index;
                // print("Selezionato lo slot con indice ${inventorySlot.index}");
              
            },
            child:  getChild());
      //* inventory
      case SlotType.inventory:
        return Draggable(
          //*feedback è quello che vedo quando trascino
          feedback: InventoryItemAndNumberWidget(inventorySlot: inventorySlot),
          //*childWnhenDragging è cosa vedo al posto dell'originale quando trascino
          childWhenDragging: InventorySlotBackgroundWidget(
            slotType: slotType,
            index: inventorySlot.index,
          ),
          child:
            //*core part of inventory slot
             getChild()),
          ,
        );
    }
  }

  Stack getChild() {
    return Stack(
      children: [
        InventorySlotBackgroundWidget(
          slotType: slotType,
          index: inventorySlot.index,
        ),
        InventoryItemAndNumberWidget(
          inventorySlot: inventorySlot,
        )
      ],
    );
  }
}
