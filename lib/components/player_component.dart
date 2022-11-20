import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:minecraft/components/block_component.dart';
import 'package:minecraft/global/global_game_reference.dart';
import 'package:minecraft/global/player_data.dart';
import 'package:minecraft/global/world_data.dart';
import 'package:minecraft/main_game.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../resources/blocks.dart';

//ANIMATED SPRITE!
class PlayerComponent extends SpriteAnimationComponent with CollisionCallbacks {
  final Vector2 playerDimensions = Vector2(60, 60); //* src Size

  final double stepTime = 0.3;
  bool isFacingRight = true;
  double yVelocity = 0; //falling in the y axis

  double jumpForce = 0;
  double localPlayerSpeed = 0;

  bool refreshSpeed = false;

  bool isCollidingBottom = false;
  bool isCollidingLeft = false;
  bool isCollidingRight = false;
  bool isCollidingTop = false;

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is BlockComponent &&
        BlockData.getBlockDataFor(other.block).isCollidable) {
      //* loop over intersection points
      //*player y position is at the feet! (Anchor bottomCenter)
      intersectionPoints.forEach((Vector2 individualIntesectionPoint) {
        //*sottraggo 30% altezza del player pixel per essere sicuro
        if (individualIntesectionPoint.y > (position.y - (size.y * 0.3)) &&

            //* area di intersezione > del 30% della base del player
            (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
                size.x * 0.4) {
          //*guardo che blocco è

          isCollidingBottom = true;

          // log("is collidin bottom and");
          // position.y = other.position.y;
          yVelocity = 0; //*si cade da "fermi"
        }
        //*TOP
        if (individualIntesectionPoint.y < (position.y - (size.y * 0.75)) &&
            //* area di intersezione > del 30% della base del player
            (intersectionPoints.first.x - intersectionPoints.last.x).abs() >
                size.x * 0.4 &&
            jumpForce > 0) {
          //*STIAMO SALTANDO E ABBIAMO TOCCATO IN ALTO
          isCollidingTop = true;
        }
        //*DX SINISTRA (above = minore! 0 sta in cima)
        if (individualIntesectionPoint.y < (position.y - (size.y * 0.3))) {
          // log("COLLIDING HORIZONTALLY");
          // log("is colliding horizontally");
          //*check isFacingRight
          if (individualIntesectionPoint.x > position.x) {
            isCollidingRight = true;
          } else {
            isCollidingLeft = true;
          }
        }
      });
    }
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
    log("LOADING");

    super.onLoad();
    add(RectangleHitbox());
    priority = 2; //SULLO STACK VISIVO

    anchor = Anchor.bottomCenter; //ANCORAGGIO DEL COMPONENT

    //WALKING
    playerWalkingSpriteSheet = SpriteSheet(
        image: Flame.images
            .fromCache('sprite_sheets/player/player_walking_sprite_sheet.png'),
        //*size of the single image
        srcSize: playerDimensions);
    //IDLE
    playerIdleSpriteSheet = SpriteSheet(
        image: Flame.images
            .fromCache('sprite_sheets/player/player_idle_sprite_sheet.png'),
        //*size of the single image
        srcSize: playerDimensions);

    //* initial values
    // size = Vector2(100, 100);
    position = Vector2(100, 400);
    animation = idleAnimation;
    //*refresh localspeed con timer
    add(TimerComponent(
        period: 1,
        repeat: true,
        onTick: () {
          refreshSpeed = true;
        }));
  }

  void fallingLogic(double dt) {
    //!SOLO se non cado
    if (!isCollidingBottom) {
//*solo fino a una certa velocità
      if (yVelocity < (GameMethods.gravity * dt) * 10) {
        position.y += yVelocity; //*each dt step y = yVelocity*dt

        // position.y = GameMethods.getIndexPostionFromPixels(position).y;
        //*correggo
        yVelocity += GameMethods.gravity * dt; //*dV/dt costante
      } else {
        position.y += yVelocity; //*not increasing
        // position.y = GameMethods.getIndexPostionFromPixels(position).y;
      }
    } else {
      // Vector2 groundBlockPosition =
      //     GameMethods.getIndexPostionFromPixels(position);

      // position.y =
      //     (groundBlockPosition.y).floorToDouble() * GameMethods.blockSize.y;
    }
  }

  //* come animare?
  @override
  void update(double dt) {
    super.update(dt);
    movementLogic(dt);

    fallingLogic(dt);
    jumpingLogic();
    setAllCollisionToFalse(); //*resetting
    if (refreshSpeed) {
      localPlayerSpeed = (playerSpeed * GameMethods.blockSize.x) * dt;
      refreshSpeed = false; //reset
    }
  }

  void jumpingLogic() {
    if (jumpForce > 0) {
      //*STO SALTANDO

      position.y -= jumpForce;
      jumpForce -= GameMethods.blockSize.x * 0.15;
      //*SE TOCCO SMETTO DI SALTARE
      if (isCollidingTop) {
        jumpForce = 0;
      }
    }
  }

  void setAllCollisionToFalse() {
    isCollidingBottom =
        false; //*reset per vedere cosa succede al prossimo frame
    isCollidingLeft = false;
    isCollidingTop = false;
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
          position.x -= localPlayerSpeed;
          animation = walkingAnimation;
          if (isFacingRight) {
            flipHorizontallyAroundCenter();
            isFacingRight = false;
          }
        }

        break;
      case ComponentMotionState.walkingRight:
        if (!isCollidingRight) {
          position.x += localPlayerSpeed;
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
    if (playerData.motionState == ComponentMotionState.jumping &&
        isCollidingBottom) {
      jumpForce = GameMethods.blockSize.x * 1;
    }
  }
}
