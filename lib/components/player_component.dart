import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

//ANIMATED SPRITE!
class PlayerComponent extends SpriteAnimationComponent {
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
    super.update(dt);
    position.x += 1;
  }
}
