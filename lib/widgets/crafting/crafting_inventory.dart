import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft/widgets/crafting/standard_crafting_grid.dart';

import '../../global/global_game_reference.dart';
import '../inventory/inventory_storage_widget.dart';

class CraftingInventory extends StatelessWidget {
  const CraftingInventory({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GlobalGameReference.instance.mainGameRef.worldData.craftingManager
              .craftingInventoryIsOpen.value
          ? Positioned.fill(
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: const [
                    InventoryStorageWidget(),
                    StandardCraftingGridWidget(),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}
