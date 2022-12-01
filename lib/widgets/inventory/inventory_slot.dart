import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/global/global_game_reference.dart';

import 'package:minecraft/global/inventory.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/inventory/inventory_slot_background.dart';

import '../../components/item_component.dart';
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
        return GestureDetector(
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
            onLongPress: () {
              GlobalGameReference
                  .instance
                  .mainGameRef
                  .worldData
                  .inventoryManager
                  .currentSelectedSlot
                  .value = inventorySlot.index;

              //* spawning position:
              int offset = 2;

              Vector2 spawningPosition = Vector2(
                  GameMethods.playerXIndexPosition + offset,
                  GameMethods.playerYIndexPosition -
                      maxReach); //* -maxReach cade da più in alto

              //*loop su tutti gli item
              for (var i = 0; i < inventorySlot.count.value; i++) {
                GlobalGameReference.instance.mainGameRef.worldData.items.add(
                    ItemComponent(
                        spawnBlockIndex: spawningPosition,
                        block: inventorySlot.block!));
              } //* fine loop
              inventorySlot.emptySlot(); //*svuoto
            },
            child: getChild());
      //* inventory
      case SlotType.inventory:
        //*per gesitre il click lungo
        return GestureDetector(
          onLongPress: () {
            for (int i = 0; i < inventorySlot.count.value / 2; i++) {
              //fino a metà valore
              GlobalGameReference
                  .instance.mainGameRef.worldData.inventoryManager
                  .addBlockToInventory(inventorySlot.block!);
              inventorySlot.decrementSlot(); //riduco da quello di partenza
            }
          },
          child: Draggable(
            //*dati associati con il draggable
            data: inventorySlot,
            //*feedback è quello che vedo quando trascino
            feedback:
                InventoryItemAndNumberWidget(inventorySlot: inventorySlot),
            //*childWnhenDragging è cosa vedo al posto dell'originale quando trascino
            childWhenDragging: InventorySlotBackgroundWidget(
              slotType: slotType,
              index: inventorySlot.index,
            ),
            child: //*core part of inventory slot
                getChild(),
          ),
        );
    }
  }

  //*return a dragtarget dove posizionare i draggables
  Widget getDragTarget() {
    return SizedBox(
      width: GameMethods.slotSize,
      height: GameMethods.slotSize,
      child: DragTarget(
        builder: (context, candidateData, rejectedData) => Container(),
        //*quando ho rilasciato il draggable
        onAccept: (InventorySlot draggingInventorySlot) {
          if (inventorySlot.isEmpty) {
            inventorySlot.block = draggingInventorySlot.block;
            inventorySlot.count.value = draggingInventorySlot.count.value;
            draggingInventorySlot.emptySlot();
          } else {
            //*NON ERA VUOTO
            if (inventorySlot.block == draggingInventorySlot.block) {
              //*STESSO TIPO DI BLOCCO
              //* somma <= stack?? (64)
              if (inventorySlot.count.value +
                      draggingInventorySlot.count.value <=
                  stack) {
                //*POSSO UNIRLI
                inventorySlot.count.value += draggingInventorySlot.count.value;
                draggingInventorySlot.emptySlot();
              }
            } else {
              //*BLOCCHI DIVERSI: SCAMBIO
              InventorySlot tmp = InventorySlot(index: inventorySlot.index)
                ..block = inventorySlot.block
                ..count.value = inventorySlot.count.value;
              inventorySlot.block = draggingInventorySlot.block;
              inventorySlot.count.value = draggingInventorySlot.count.value;
              draggingInventorySlot.block = tmp.block;
              draggingInventorySlot.count.value = tmp.count.value;
            }
          }
        },
      ),
    );
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
        ),
        getDragTarget()
      ],
    );
  }
}
