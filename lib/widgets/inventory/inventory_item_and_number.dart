import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:minecraft/global/inventory.dart';

import '../../resources/blocks.dart';
import '../../utils/game_methods.dart';

class InventoryItemAndNumberWidget extends StatelessWidget {
  final InventorySlot inventorySlot;
  const InventoryItemAndNumberWidget({super.key, required this.inventorySlot});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: GameMethods.slotSize,
        height: GameMethods.slotSize,
        child: Obx(
          //* OSSERVABILE QUANDO COUNT CAMBIA QUELLO CHE STA DENTRO REBUILD
          () {
            return inventorySlot.count.value > 0
                ? Stack(
                    children: [
                      Positioned(
                          left: 0,
                          right: 0,
                          top: 0,
                          bottom: 0,
                          child: Padding(
                            padding:
                                EdgeInsets.all(GameMethods.blockSize.y / 4),
                            child: SpriteWidget(
                                sprite: GameMethods.getSpriteFromBlock(
                                    inventorySlot.block!)),
                          )),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: GameMethods.slotSize / 6,
                                right: GameMethods.slotSize / 6),
                            child: Text(
                              inventorySlot.count.toString(),
                              style: TextStyle(
                                  shadows: const [
                                    BoxShadow(
                                        color: Colors.black,
                                        offset: Offset(1, 1))
                                  ],
                                  color: Colors.white,
                                  fontFamily: "MinecraftFont",
                                  fontSize: GameMethods.slotSize / 4),
                            ),
                          )),
                    ],
                  )
                : Container(); //*Container vuoto se slot vuoto
          },
        ));
  }
}
