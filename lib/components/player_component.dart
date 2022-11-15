import 'dart:developer';

import 'package:flame/collisions.dart';
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
class PlayerComponent extends SpriteAnimationComponent with CollisionCallbacks {
  final Vector2 playerDimensions = Vector2(60, 60); //* src Size

  final double stepTime = 0.3;
  bool isFacingRight = true;
  double yVelocity = 0; //falling in the y axis

  bool isCollidingBottom = false;
  bool isCollidingLeft = false;
  bool isCollidingRight = false;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    //* loop over intersection points
    //*player y position is at the feet! (Anchor bottomCenter)
    intersectionPoints.forEach((Vector2 individualIntesectionPoint) {
      //*sottraggo 30% altezza del player pixel per essere sicuro
      if (individualIntesectionPoint.y > (position.y - (size.y * 0.3)) &&
          //* area di intersezione > del 30% della base del player
          (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
              size.x * 0.4) {
        isCollidingBottom = true;
      }
      //*DX SINISTRA (above = minore! 0 sta in cima)
      if (individualIntesectionPoint.y < (position.y - (size.y * 0.3))) {
        log("COLLIDING HORIZONTALLY");
        //*check isFacingRight
        if (individualIntesectionPoint.x > position.x) {
          isCollidingRight = true;
        } else {
          isCollidingLeft = true;
        }
      }
    });
  }

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
    add(RectangleHitbox());
    priority = 2; //SULLO STACK VISIVO

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

  void fallingLogic(double dt) {
    //!SOLO se non cado
    if (!isCollidingBottom) {
//*solo fino a una certa velocità
      if (yVelocity < GameMethods.gravity * dt * 5) {
        position.y += yVelocity - 0.3 * size.y; //*each dt step y = yVelocity*dt
        //*correggo
        yVelocity += GameMethods.gravity * dt; //*dV/dt costante
      } else {
        position.y += yVelocity; //*not increasing
      }
    }
  }

  //* come animare?
  @override
  void update(double dt) {
    super.update(dt);
    movementLogic(dt);
    fallingLogic(dt);
    setAllCollisionToFalse(); //*resetting
  }

  void setAllCollisionToFalse() {
    isCollidingBottom =
        false; //*reset per vedere cosa succede al prossimo frame
    isCollidingLeft = false;
    isCollidingRight = false; //*resetting
  }

  @override
  void onGameResize(Vector2 newScreenSize) {
    super.onGameResize(newScreenSize);

    size = GameMethods.blockSize * 1.5;
  }

  void move(ComponentMotionState componentMotionState, double dt) {
    switch (componentMotionState) {
      case ComponentMotionState.walkingLeft:
        if (!isCollidingLeft) {
          position.x -= (playerSpeed * GameMethods.blockSize.x) * dt;
          animation = walkingAnimation;
          if (isFacingRight) {
            flipHorizontallyAroundCenter();
            isFacingRight = false;
          }
        }

        break;
      case ComponentMotionState.walkingRight:
        if (!isCollidingRight) {
          position.x += (playerSpeed * GameMethods.blockSize.x) * dt;
          if (!isFacingRight) {
            flipHorizontallyAroundCenter();
            isFacingRight = true;
          }
          animation = walkingAnimation;
        }

        break;
      default:
        break;
    }
  }

  void movementLogic(double dt) {
    //*prendo l'istanza globale
    MainGame gameRef = GlobalGameReference.instance.mainGameRef;
    //*prendo i dati del mondo
    WorldData worldData = gameRef.worldData;
    //*prendo i dati del player di quel mondo;
    PlayerData playerData = worldData.playerData;
    //*moving left
    if (playerData.motionState == ComponentMotionState.walkingLeft) {
      move(ComponentMotionState.walkingLeft, dt);
    }
    //*moving right
    if (playerData.motionState == ComponentMotionState.walkingRight) {
      move(ComponentMotionState.walkingRight, dt);
    }
    if (playerData.motionState == ComponentMotionState.idle) {
      animation = idleAnimation;
    }
  }
}
