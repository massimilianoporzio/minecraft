import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/main_game.dart';

//ANIMATED SPRITE!
class PlayerComponent extends SpriteAnimationComponent {
  final double speed = 40;
  @override
  Future<void>? onLoad() async {
    super.onLoad();
    SpriteSheet playerSpriteSheet = SpriteSheet(
        image: await Flame.images
            .load('sprite_sheets/player/player_walking_sprite_sheet.png'),
        //*size of the single image
        srcSize: Vector2.all(60));
    //*anima usando la prima riga (0)
    animation = playerSpriteSheet.createAnimation(
        row: 0,
        //in seconds
        stepTime: 0.1);
    size = Vector2(100, 100);
  }

  //* come animare?
  @override
  void update(double dt) {
    //*prendo l'istanza globale
    MainGame gameRef = GlobalGameReference.instance.mainGameRef;
    //*prendo i dati del mondo
    WorldData worldData = gameRef.worldData;
    //*prendo i dati del player di quel mondo;
    PlayerData playerData = worldData.playerData;
    super.update(dt);
    if (playerData.motionState == ComponentMotionState.walkingLeft) {
      position.x -= speed * dt;
    }
    if (playerData.motionState == ComponentMotionState.walkingRight) {
      position.x += speed * dt;
    }
  }
}
