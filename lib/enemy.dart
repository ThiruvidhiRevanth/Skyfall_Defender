import 'package:flame/components.dart';

class Enemy extends SpriteComponent with HasGameRef {
  Enemy({
    required Vector2 position,
    required double screenWidth,
    required double screenHeight,
  }) : super(
          position: position,
          size: Vector2(screenWidth * 0.1, screenHeight*0.05), // Adjust size as per width
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('block.png');
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += 50 * dt;
  }
}

