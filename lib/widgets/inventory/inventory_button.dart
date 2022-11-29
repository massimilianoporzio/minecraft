import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';

class InventoryButtonWidget extends StatelessWidget {
  const InventoryButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print("Button is clicked");
        GlobalGameReference.instance.mainGameRef.worldData.inventoryManager
                .inventoryIsOpen.value =
            !GlobalGameReference.instance.mainGameRef.worldData.inventoryManager
                .inventoryIsOpen.value;
      },
      child: SizedBox(
        height: GameMethods.slotSize,
        width: GameMethods.slotSize,
        child: FittedBox(
          child: Image.asset('assets/images/inventory/inventory_button.png'),
        ),
      ),
    );
  }
}
