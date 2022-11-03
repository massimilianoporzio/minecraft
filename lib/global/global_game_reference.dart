//*Istanza globale del gioco comune a tutto
import 'package:get/get.dart';
import 'package:minecraft/main_game.dart';

class GlobalGameReference {
  late MainGame mainGameRef; //tiene il riferimento al main Game

  //GETTER DEL SINGLEOTN
  static GlobalGameReference get instance {
    return Get.put(GlobalGameReference()); //*singleton!
  }
}
