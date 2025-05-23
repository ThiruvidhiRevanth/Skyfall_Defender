import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart'; 
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:universal_html/html.dart' as html;
import 'bullet.dart';
import 'enemy.dart';
import 'player.dart';
import 'game_controller.dart';
import 'package:flutter/material.dart';
import 'dart:async' as dart_async;
import 'package:audioplayers/audioplayers.dart';
import 'dart:io' show Platform;
import 'package:shared_preferences/shared_preferences.dart';



class BlockGame extends FlameGame with TapDetector, HasCollisionDetection, KeyboardEvents {
  final GameController controller = Get.find();
  final Size screenSize;

  BlockGame(this.screenSize);

  late Player player;
  final Random _rand = Random();
  int score = 0;
  int i=0;
  int highScore = 0;
  late TextComponent highScoreText;
  bool isGameOver = false;
  late TextComponent scoreText;
  dart_async.Timer? spawnTimer;
  final AudioPlayer _eventPlayer = AudioPlayer();

  @override
  Future<void> onLoad() async {
    score = 0;
    isGameOver = false;
         SharedPreferences prefs = await SharedPreferences.getInstance();
         highScore = prefs.getInt('highScore') ?? 0;

    try {
      await _eventPlayer.setSource(AssetSource('audio/game_fail.mp3'));
      await _eventPlayer.setSource(AssetSource('audio/game_start.mp3'));
    } catch (e) {
      print('Event audio preload error: $e');
    }

    final bg = SpriteComponent()
      ..sprite = await loadSprite('background.png')
      ..size = size
      ..position = Vector2.zero()
      ..priority = -1;
    add(bg);

    player = Player(
      position: Vector2(controller.playerX.value, controller.playerY.value),
      screenWidth: screenSize.width,
      screenHeight: screenSize.height,
    );
    add(player);

    controller.playerX.listen((x) => player.position.x = x);
    controller.playerY.listen((y) => player.position.y = y);

    scoreText = TextComponent(
      text: 'Score: 0',
      position: Vector2(20, 50),
      anchor: Anchor.topLeft,
       textRenderer: TextPaint(style: const TextStyle(fontSize: 18, color: Colors.white)),
    );
    add(scoreText);

    highScoreText = TextComponent(
    text: 'High Score: $highScore',
    position: Vector2(20, 80),
    anchor: Anchor.topLeft,
    textRenderer: TextPaint(style: const TextStyle(fontSize: 18, color: Colors.white)),
  );
  add(highScoreText);
  
  }
  KeyEventResult onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {

  final bool isKeyboardPlatform = !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  
  if ((isKeyboardPlatform || kIsWeb) && !isGameOver && 
      !overlays.isActive('Splash') && !overlays.isActive('GameOver')) {

    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        controller.startMovingLeft();
      } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        controller.startMovingRight();
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        controller.startshoot(this);
      } else if (event.logicalKey == LogicalKeyboardKey.keyP) {
        controller.togglePauseResume(this);
      }
    }

    if (event is KeyUpEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
          event.logicalKey == LogicalKeyboardKey.arrowRight) {
        controller.stopMoving();
      } else if (event.logicalKey == LogicalKeyboardKey.space) {
        controller.stopShooting();
      }
    }
  }

  return KeyEventResult.handled;
}
  bool _isMobileBrowser() {
  if (!kIsWeb) return false;

  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('iphone') ||
         userAgent.contains('android') ||
         userAgent.contains('ipad') ||
         userAgent.contains('mobile');
}


  void startGame() async {
    
    isGameOver = false;
    score = 0;
    scoreText.text = 'Score: 0';
    overlays.remove('Splash');
  try {
              FlameAudio.play('game_start.mp3', volume: 0.5);

          } catch (e) {
            print('Game over audio error: $e');
          }

  final countdown = TextComponent(
    text: '',
    position: size / 2,
    anchor: Anchor.center,
    textRenderer: TextPaint(style: const TextStyle(fontSize: 64, color: Colors.white)),
  );
  add(countdown);

  for (int i = 3; i >= 1; i--) {
    countdown.text = '$i';
    await Future.delayed(const Duration(seconds: 1));
  }
countdown.text = 'GO!';
await Future.delayed(const Duration(milliseconds: 500));
  countdown.removeFromParent(); // remove countdown text

  
   if ((!kIsWeb && (Platform.isAndroid || Platform.isIOS)) || _isMobileBrowser()) {
  overlays.add('GameControls');
}

 
    controller.playBgm();
    resumeEngine();
    startSpawning();
  }

  void startSpawning() {
    spawnTimer?.cancel(); 
    spawnTimer = dart_async.Timer.periodic(const Duration(seconds: 1), (_) {
      if (!isGameOver && !paused) {
        double spawnX = _rand.nextDouble() * (screenSize.width - 50);
        add(Enemy(
          position: Vector2(spawnX, 0),
          screenWidth: screenSize.width,
          screenHeight: screenSize.height,
        ));
      }
    });
  }

  void pauseGame() {
    pauseEngine();
    controller.pauseBgm();
    spawnTimer?.cancel();
  }

  void resumeGame() {
    controller.resumeBgm();
    resumeEngine();
    startSpawning();
  }

  void resetGame() {
    children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    children.whereType<Bullet>().forEach((b) => b.removeFromParent());
    score = 0;
    isGameOver = false;
    scoreText.text = 'Score: 0';
    player.position.x = controller.playerX.value;
   
   if ((!kIsWeb && (Platform.isAndroid || Platform.isIOS)) || _isMobileBrowser()){
      overlays.add('GameControls');
    }
    resumeGame();
  }

  @override
  void update(double dt) {
    if (isGameOver) return;
    try {
      super.update(dt);
      for (final bullet in children.whereType<Bullet>()) {
        for (final enemy in children.whereType<Enemy>()) {
          if (bullet.toRect().overlaps(enemy.toRect())) {
            bullet.removeFromParent();
            enemy.removeFromParent();
            score += 1;
            scoreText.text = 'Score: $score';
                        if (score > highScore) {
    highScore = score;
    highScoreText.text = 'High Score: $highScore';
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('highScore', highScore);
    });}
          }
        }
      }
      if ((!kIsWeb && (Platform.isAndroid || Platform.isIOS)) || _isMobileBrowser()){
         i=220;
        
      }
      else{
        i=70;
      }
      for (final enemy in children.whereType<Enemy>()) {
       
        if (enemy.position.y + enemy.size.y >= screenSize.height - i) {
          try {
            _eventPlayer.stop();
            _eventPlayer.play(AssetSource('audio/game_fail.mp3'));
          } catch (e) {
            print('Game over audio error: $e');
          }
          controller.stopBgm();
          gameOver();
          return;
        }
      }
    } catch (e) {
      print('Game loop error: $e');
    }
  }

  void gameOver() {
    isGameOver = true;
    pauseGame();
    overlays.add('GameOver');
  }

  @override
  void onRemove() {
    _eventPlayer.dispose();
    super.onRemove();
  }
}