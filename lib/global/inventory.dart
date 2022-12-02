import 'package:get/get.dart';
import 'package:minecraft/utils/constants.dart';

import '../resources/blocks.dart';

class InventoryManager {
  Rx<int> currentSelectedSlot =
      0.obs; //*index dello slot selezionato da cui pescare

  Rx<bool> inventoryIsOpen = false.obs; //*osservabile ora!

  List<InventorySlot> inventorySlots =
      List.generate(36, (index) => InventorySlot(index: index));

  bool addBlockToInventory(dynamic block) {
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
  dynamic block; //*può essere Block ma anche ITEM
  final index;
  Rx<int> count = 0
      .obs; //* osservabile del package "GET" ogni volta che vcambia forza "build"
//*|cone le reactive di VUE3|
  InventorySlot({required this.index});

  String get slotDescrption {
    if (count.value == 0) {
      return "Empty";
    } else {
      return "${count.value} " "of $block";
    }
  }

  bool get isEmpty {
    return count.value == 0;
  }

  void emptySlot() {
    block = null;
    count.value = 0;
  }

  @override
  String toString() {
    // TODO: implement toString
    return "Slot $index: $slotDescrption";
  }

  bool incrementCount() {
    if (count.value < stack) {
      //* agg solo se minore di stack
      count.value++;
      return true;
    }
    return false;
  }

  void decrementSlot() {
    count.value--;
    if (count.value == 0) {
      block = null; //*SVUOTO
    }
  }
}
