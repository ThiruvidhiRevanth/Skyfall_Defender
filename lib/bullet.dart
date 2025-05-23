import 'package:flame/components.dart';
import 'package:flutter/painting.dart';

class Bullet extends RectangleComponent {
  Bullet(  { required Vector2 position,
    required double screenWidth,
    required double screenHeight,
  })
      : super(
          position: position,
          size: Vector2(screenWidth*0.01, screenHeight*0.015),
          paint: Paint()..color = const Color(0xFFFFFFFF),
        );

  @override
  void update(double dt) {
    super.update(dt);
    position.y -= 200 * dt;
    if (position.y < 0) removeFromParent();
  }
}
