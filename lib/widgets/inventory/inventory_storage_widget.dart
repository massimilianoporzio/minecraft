import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../../global/global_game_reference.dart';
import 'inventory_slot.dart';

class InventoryStorageWidget extends StatelessWidget {
  const InventoryStorageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double inventoryStorageSize = GameMethods.slotSize * 9.5;
    return Stack(
      children: [
        SizedBox(
            width: inventoryStorageSize,
            height: inventoryStorageSize,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Image.asset(
                  'assets/images/inventory/inventory_background.png'),
            )),
        Positioned.fill(
          child: Align(
              alignment: Alignment.bottomCenter, //* ma la colonna occupa tutto
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getRow(3),
                  getRow(2),
                  getRow(1),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: GameMethods.slotSize / 2),
                    child: getRow(0), //* prima riga dal basso
                  )
                ],
              )),
        )
      ],
    );
  }

  Row getRow(int rowIndex) {
    return Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          9,
          (index) => InventorySlotWidget(
              slotType: SlotType.inventory,
              inventorySlot: GlobalGameReference.instance.mainGameRef.worldData
                  .inventoryManager.inventorySlots[9 * rowIndex + index]),
        ));
  }
}
