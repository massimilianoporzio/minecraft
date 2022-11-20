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
import 'package:minecraft/resources/entity.dart';
import 'package:minecraft/utils/constants.dart';
import 'package:minecraft/utils/game_methods.dart';

import '../resources/blocks.dart';

//ANIMATED SPRITE!
class PlayerComponent extends Entity {
  final Vector2 playerDimensions = Vector2(60, 60); //* src Size

  final double stepTime = 0.3;

  double localPlayerSpeed = 0;

  bool refreshSpeed = false;

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
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is BlockComponent &&
        BlockData.getBlockDataFor(other.block).isCollidable) {
      //*chima la collisione su Entity ma solo se era isCollidable
      super.onCollision(intersectionPoints, other);
    }
  }

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

  @override
  void onGameResize(Vector2 newScreenSize) {
    super.onGameResize(newScreenSize);

    size = GameMethods.blockSize * 1.5;
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
      move(ComponentMotionState.walkingLeft, dt, localPlayerSpeed);
      animation = walkingAnimation;
    }
    //*moving right
    if (playerData.motionState == ComponentMotionState.walkingRight) {
      move(ComponentMotionState.walkingRight, dt, localPlayerSpeed);
      animation = walkingAnimation;
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
