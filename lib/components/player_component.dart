import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/main_game.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

//ANIMATED SPRITE!
class PlayerComponent extends SpriteAnimationComponent {
  final Vector2 playerDimensions = Vector2(60, 60); //* src Size
  final double speed = 5;
  final double stepTime = 0.3;
  bool isFacingRight = true;
  double yVelocity = 0; //falling in the y axis

  late SpriteSheet playerWalkingSpriteSheet; //*loading spritesheet is async!
  late SpriteSheet playerIdleSpriteSheet; //* so we use "late"

  late SpriteAnimation walkingAnimation =
      playerWalkingSpriteSheet.createAnimation(
          row: 0,
          //in seconds
          stepTime: stepTime);
  late SpriteAnimation idleAnimation = playerIdleSpriteSheet.createAnimation(
      row: 0,
      //in seconds
      stepTime: stepTime);

  @override
  Future<void>? onLoad() async {
    super.onLoad();
    priority = 100; //SULLO STACK VISIVO

    anchor = Anchor.bottomCenter; //ANCORAGGIO DEL COMPONENT

    //WALKING
    playerWalkingSpriteSheet = SpriteSheet(
        image: await Flame.images
            .load('sprite_sheets/player/player_walking_sprite_sheet.png'),
        //*size of the single image
        srcSize: playerDimensions);
    //IDLE
    playerIdleSpriteSheet = SpriteSheet(
        image: await Flame.images
            .load('sprite_sheets/player/player_idle_sprite_sheet.png'),
        //*size of the single image
        srcSize: playerDimensions);

    //* initial values
    // size = Vector2(100, 100);
    position = Vector2(100, 400);
    animation = idleAnimation;
  }

  //* come animare?
  @override
  void update(double dt) {
    super.update(dt);
    movementLogic();
    //*solo fino a una certa velocità
    if (yVelocity < gravity * 5) {
      position.y += yVelocity; //*each dt step y = yVelocity*dt
      yVelocity += gravity; //*dV/dt costante
    } else {
      position.y += yVelocity; //*not increasing
    }
  }

  @override
  void onGameResize(Vector2 newScreenSize) {
    super.onGameResize(newScreenSize);

    size = GameMethods.getBlockSize() * 1.5;
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
      animation = walkingAnimation;
      if (isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = false;
      }
      position.x -= speed;
    }
    //*moving right
    if (playerData.motionState == ComponentMotionState.walkingRight) {
      animation = walkingAnimation;
      if (!isFacingRight) {
        flipHorizontallyAroundCenter();
        isFacingRight = true;
      }
      position.x += speed;
    }
    if (playerData.motionState == ComponentMotionState.idle) {
      animation = idleAnimation;
    }
  }
}
