import 'package:flutter/material.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot.dart';
import 'package:minecraft/widgets/inventory/inventory_storage_widget.dart';

class PlayerInventoryWidget extends StatelessWidget {
  const PlayerInventoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Align(
        alignment: Alignment.center,
        child: Stack(
          children: [
            InventoryStorageWidget(),
            Positioned(
              left: 0,
              right: 0,
              top: 10,
              child: Container(
                height: GameMethods.slotSize * 4,
                width: GameMethods.slotSize * 9,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }
}
