import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/components/item_component.dart';
import 'package:minecraft/resources/blocks.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../../global/global_game_reference.dart';
import '../../global/inventory.dart';
import 'inventory_slot.dart';

class InventoryStorageWidget extends StatelessWidget {
  const InventoryStorageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double inventoryStorageSize = GameMethods.slotSize * 9.5;
    return Row(children: [
      //* THROWING AREA
      getDragTarget(Direction.left),
      Padding(
        padding: EdgeInsets.only(bottom: GameMethods.slotSize / 1.5),
        child: SizedBox(
          height: GameMethods.getScreenSize().height * 0.8,
          width: GameMethods.getScreenSize().height * 0.8,
          child: FittedBox(
            child: Stack(
              children: [
                SizedBox(
                    width: inventoryStorageSize,
                    height: inventoryStorageSize,
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: Image.asset(
                          'assets/images/inventory/inventory_background.png'),
                    )),
                Positioned.fill(
                  child: Align(
                      alignment:
                          Alignment.bottomCenter, //* ma la colonna occupa tutto
                      child: Column(
                        mainAxisSize:
                            MainAxisSize.min, //*così la costringo al minimo
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
            ),
          ),
        ),
      ),
      //*THROWING AREA
      getDragTarget(Direction.right),
    ] //* RIGA
        );
  }

  Widget getDragTarget(Direction directction) {
    return Expanded(
        child: InkWell(
      onTap: () {
        GlobalGameReference.instance.mainGameRef.worldData.craftingManager
            .craftingInventoryIsOpen.value = false;
      },
      child: SizedBox(
        height: GameMethods.slotSize * 9.5,
        child: DragTarget(
          builder: (context, candidateData, rejectedData) => Container(),
          onAccept: (InventorySlot inventorySlot) async {
            //* spawning position:
            int offset = directction == Direction.left ? -1 : 1;

            Vector2 spawningPosition = Vector2(
                GameMethods.playerXIndexPosition + offset,
                GameMethods.playerYIndexPosition -
                    maxReach); //* -maxReach cade da più in alto

            //*loop su tutti gli item
            for (var i = 0; i < inventorySlot.count.value; i++) {
              GlobalGameReference.instance.mainGameRef.worldData.items.add(
                  ItemComponent(
                      spawnBlockIndex: spawningPosition,
                      item: inventorySlot.block!));
            } //* fine loop
            inventorySlot.emptySlot(); //*svuoto
          },
        ),
      ),
    ));
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
