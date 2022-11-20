import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

import '../global/player_data.dart';
import '../utils/game_methods.dart';

class Entity extends SpriteAnimationComponent with CollisionCallbacks {
  bool isFacingRight = true;
  double yVelocity = 0; //falling in the y axis
  double jumpForce = 0;

  bool isCollidingBottom = false;
  bool isCollidingLeft = false;
  bool isCollidingRight = false;
  bool isCollidingTop = false;

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
    }
  }

  void setAllCollisionToFalse() {
    isCollidingBottom =
        false; //*reset per vedere cosa succede al prossimo frame
    isCollidingLeft = false;
    isCollidingTop = false;
    isCollidingRight = false; //*resetting
  }

  void move(
      ComponentMotionState componentMotionState, double dt, double speed) {
    switch (componentMotionState) {
      case ComponentMotionState.walkingLeft:
        if (!isCollidingLeft) {
          position.x -= speed;

          if (isFacingRight) {
            flipHorizontallyAroundCenter();
            isFacingRight = false;
          }
        }

        break;
      case ComponentMotionState.walkingRight:
        if (!isCollidingRight) {
          position.x += speed;
          if (!isFacingRight) {
            flipHorizontallyAroundCenter();
            isFacingRight = true;
          }
        }

        break;
      default:
        break;
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
}
