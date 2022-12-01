import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/crafting/player_inventory_crafting_grid.dart';
import 'package:minecraft/widgets/crafting/standard_crafting_grid.dart';
import 'package:minecraft/widgets/inventory/inventory_slot.dart';
import 'package:minecraft/widgets/inventory/inventory_storage_widget.dart';

class PlayerInventoryWidget extends StatelessWidget {
  const PlayerInventoryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GlobalGameReference.instance.mainGameRef.worldData.inventoryManager
              .inventoryIsOpen.value
          ? Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: const [
                    InventoryStorageWidget(),
                    PlayerInventoryCraftingGridWidget(),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
