import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:minecraft/global/crafting_manager.dart';
import 'package:minecraft/global/global_game_reference.dart';

import 'package:minecraft/global/inventory.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';
import 'package:minecraft/widgets/crafting/crafting_inventory.dart';
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
                        item: inventorySlot.block!));
              } //* fine loop
              inventorySlot.emptySlot(); //*svuoto
            },
            child: getChild());
      //* inventory
      case SlotType.inventory:
        //*per gesitre il click lungo
        return GestureDetector(
          onLongPress: () {
            for (int i = 0; i <= inventorySlot.count.value / 2; i++) {
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
      case SlotType.crafting:

        //*per gesitre il click lungo
        return GestureDetector(
          onLongPress: () {
            for (int i = 0; i <= inventorySlot.count.value / 2; i++) {
              //fino a metà valore
              GlobalGameReference
                  .instance.mainGameRef.worldData.inventoryManager
                  .addBlockToInventory(inventorySlot.block!);
              inventorySlot.decrementSlot(); //riduco da quello di partenza
            }
          },
          child: Draggable(
            onDragCompleted: () {
              //*quando ho fatto un drag dalla zona di craft ricerca di nuovo ricetta
              GlobalGameReference.instance.mainGameRef.worldData.craftingManager
                  .checkForRecipe();
            },
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
      case SlotType.craftingOutput:
        return GestureDetector(
            //*onTap:
            onTap: () {
              //*from player 2x2 ot standard 3x3???
              if (CraftingManager.isInPlayerInventory()) {
                //*prendo l'ultimo slot
                InventorySlot outputSlot = GlobalGameReference
                    .instance
                    .mainGameRef
                    .worldData
                    .craftingManager
                    .playerInventoryCraftingGrid
                    .last;
                //*sono nel player crafting
                //*LOOP SU QUANTI NE HO IN OUTPUT
                int iterateTill = outputSlot.count.value;
                for (var i = 0; i < iterateTill; i++) {
                  //*AGGIUNGO ALLO SLOT INVENTARIO e SE A BUON FINE
                  if (GlobalGameReference
                      .instance.mainGameRef.worldData.inventoryManager
                      .addBlockToInventory(outputSlot.block!)) {
                    //*decremento nello slot di output
                    outputSlot.decrementSlot();
                  }
                }
                GlobalGameReference
                    .instance.mainGameRef.worldData.craftingManager
                    .decrementOneFromEachSlot(GlobalGameReference
                        .instance
                        .mainGameRef
                        .worldData
                        .craftingManager
                        .playerInventoryCraftingGrid);
              } else {
                //*sono nella standard 3x3
                //*prendo l'ultimo slot
                InventorySlot outputSlot = GlobalGameReference
                    .instance
                    .mainGameRef
                    .worldData
                    .craftingManager
                    .standardCraftingGrid
                    .last;
                int iterateTill = outputSlot.count.value;
                for (var i = 0; i < iterateTill; i++) {
                  //*AGGIUNGO ALLO SLOT INVENTARIO e SE A BUON FINE
                  if (GlobalGameReference
                      .instance.mainGameRef.worldData.inventoryManager
                      .addBlockToInventory(outputSlot.block!)) {
                    //*decremento nello slot di output
                    outputSlot.decrementSlot();
                  }
                }
                GlobalGameReference
                    .instance.mainGameRef.worldData.craftingManager
                    .decrementOneFromEachSlot(GlobalGameReference
                        .instance
                        .mainGameRef
                        .worldData
                        .craftingManager
                        .standardCraftingGrid);
              }
              //*controllo se ci sono ancora item per craftare
              GlobalGameReference.instance.mainGameRef.worldData.craftingManager
                  .checkForRecipe();
            }, //fine onTap,
            child: getChild()); //NO DRAGGABLE FUNCTIONALITY
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
          if (slotType != SlotType.craftingOutput) {
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
                  inventorySlot.count.value +=
                      draggingInventorySlot.count.value;
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
          }

          if (slotType == SlotType.crafting) {
            //*cerco se è ricetta per craftare qualcosa

            GlobalGameReference.instance.mainGameRef.worldData.craftingManager
                .checkForRecipe();
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
        //*solo per slot diversi da output
        getDragTarget()
      ],
    );
  }
}
