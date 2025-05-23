

import 'package:flame/components.dart';
import 'package:flame/input.dart';

class Player extends SpriteComponent with HasGameRef {


  Player({
    required Vector2 position,
    required double screenWidth,
    required double screenHeight,
  })
      : super(
          position: position,

          size: Vector2(screenWidth*0.2, screenHeight*0.1), // set size here
        );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('player.png'); // Ensure this image exists in assets
  }


}


