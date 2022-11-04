import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/main_game.dart';

//ANIMATED SPRITE!
class PlayerComponent extends SpriteAnimationComponent {
  final double speed = 5;
  bool isFacingRight = true;

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
    position = Vector2(100, 500);
  }

  //* come animare?
  @override
  void update(double dt) {
    super.update(dt);
    movementLogic();
  }

  void movementLogic() {
    //*prendo l'istanza globale
    MainGame gameRef = GlobalGameReference.instance.mainGameRef;
    //*prendo i dati del mondo
    WorldData worldData = gameRef.worldData;
    //*prendo i dati del player di quel mondo;
    PlayerData playerData = worldData.playerData;
    //*moving left
    if (playerData.motionState == ComponentMotionState.walkingLeft) {
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
      position.x -= speed;
    }
    //*moving right
    if (playerData.motionState == ComponentMotionState.walkingRight) {
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
        ;
      }
      position.x += speed;
    }
  }
}
