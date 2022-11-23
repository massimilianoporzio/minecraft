import 'package:minecraft/utils/constants.dart';

import '../resources/blocks.dart';

class InventoryManager {
  List<InventorySlot> inventorySlots =
      List.generate(5, (index) => InventorySlot(index: index));

  bool addBlockToInventory(Blocks block) {
    //*loop sugli slots
    for (InventorySlot slot in inventorySlots) {
      if (slot.block == block) {
        if (slot.incrementCount()) {
          return true;
        }
      } else if (slot.block == null) {
        slot.block = block;
        if (slot.incrementCount()) {
          return true;
        }
      }
    }
    return false;
  }
}

class InventorySlot {
  Blocks? block;
  final index;
  int count = 0;

  InventorySlot({required this.index});

  String get slotDescrption {
    if (count == 0) {
      return "Empty";
    } else {
      return "$count " "of $block";
    }
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Slot $index: $slotDescrption";
  }

  bool incrementCount() {
    if (count < stack) {
      //* agg solo se minore di stack
      count++;
      return true;
    }
    return false;
  }

  void decrementSlot() {
    count--;
    if (count == 0) {
      block = null; //*SVUOTO
    }
  }
}
