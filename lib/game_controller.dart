import 'package:flutter/foundation.dart'; 
import 'dart:async' as dart_async;
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flame/components.dart';
import 'block_game.dart';
import 'bullet.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io' show Platform;


class GameController extends GetxController {
  late double screenwidth;
  late double screenheight;
  var playerX = 0.0.obs;
  var playerY = 0.0.obs;
  dart_async.Timer? time;
  dart_async.Timer? _shootTimer;
  RxBool isPaused = false.obs;
  var showControls = false.obs;
  bool _isMoving = false;
  bool _isShooting = false;
  DateTime? _lastEffectTime;

  final AudioPlayer _movePlayer = AudioPlayer();
  // final AudioPlayer _bulletPlayer = AudioPlayer();
   
  
 

  @override
  void onInit() async {
    super.onInit();
 await _movePlayer.setSource(AssetSource('audio/bullet.mp3'));
      await _movePlayer.setSource(AssetSource('audio/move.wav'));
     FlameAudio.bgm.initialize();
   
  }

 
//   void _playEffect(AudioPlayer player, String source) async {
//   try {
//     final now = DateTime.now();
//     if (_lastEffectTime == null || now.difference(_lastEffectTime!).inMilliseconds > 50) {
//       _lastEffectTime = now;

//       if (kIsWeb ) {
        
//         final webPlayer = AudioPlayer();
//         await webPlayer.setVolume(3.0);
//         await webPlayer.play(AssetSource(source));
//         await webPlayer.dispose(); 
//       } else {
//         await player.stop();
//         await player.play(AssetSource(source));
//       }
//     }
//   } catch (e) {
//     print('Effect playback error: $e');
//   }
// }


bool _isMobileBrowser() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('mobile') ||
      userAgent.contains('android') ||
      userAgent.contains('iphone') ||
      userAgent.contains('ipad');
}

  void setScreenSize({required double width, required double height}) {
    screenwidth = width;
    screenheight = height;

  if ((!kIsWeb && (Platform.isAndroid || Platform.isIOS)) || _isMobileBrowser()) {
    playerX.value = screenwidth / 2 - playerWidth / 2;
    playerY.value = screenheight - 220;
  }else{
      playerX.value = screenwidth / 2 - playerWidth / 2;
    playerY.value = screenheight-70 ;
  }
  }

  double get playerWidth => 60.0;

  void startMovingLeft() {
    if (_isMoving) return;
    _isMoving = true;
    _movePlayer.play(AssetSource('audio/move.wav'));
    time?.cancel();
    time = dart_async.Timer.periodic(Duration(milliseconds: 100), (_) => moveLeft(noSound: true));
  }

  void startMovingRight() {
    if (_isMoving) return;
    _isMoving = true;
       _movePlayer.play(AssetSource('audio/move.wav'));
    time?.cancel();
    time = dart_async.Timer.periodic(Duration(milliseconds: 100), (_) => moveRight(noSound: true));
  }

  void stopMoving() {
    _isMoving = false;
    time?.cancel();
    time = null;
    _movePlayer.stop();
  }

  void moveLeft({bool noSound = false}) {
    if (!noSound) {
        _movePlayer.play(AssetSource('audio/move.wav'));
    }
    playerX.value = (playerX.value - 20).clamp(0, screenwidth - playerWidth);
  }

  void moveRight({bool noSound = false}) {
    if (!noSound) {
         _movePlayer.play(AssetSource('audio/move.wav'));
    }
    playerX.value = (playerX.value + 20).clamp(0, screenwidth - playerWidth);
  }

  void startshoot(BlockGame game) {
    if (_isShooting) return;
    _isShooting = true;
            _movePlayer.play(AssetSource('audio/bullet.mp3'));

    _shootTimer?.cancel();
    _shootTimer = dart_async.Timer.periodic(Duration(milliseconds: 200), (_) => shoot(game, noSound: true));
  }

  void stopShooting() {
    _isShooting = false;
    _shootTimer?.cancel();
    _shootTimer = null;
    // _bulletPlayer.stop();
  }

  void shoot(BlockGame game, {bool noSound = false}) {
    if (game.children.whereType<Bullet>().length > 10) return;
    if (!noSound) {
                  _movePlayer.play(AssetSource('audio/bullet.mp3'));

    }
    final bullet = Bullet(
      position: Vector2(playerX.value + playerWidth / 1 - 20, playerY.value - 20),
      screenWidth: screenwidth,
      screenHeight: screenheight,
    );
    game.add(bullet);
  }

  // 🔊 BGM using flame_audio
  void playBgm() {
    FlameAudio.bgm.play('background.mp3', volume: 0.5);
  }

  void pauseBgm() {
    FlameAudio.bgm.pause();
  }

  void resumeBgm() {
    FlameAudio.bgm.resume();
  }

  void stopBgm() {
    FlameAudio.bgm.stop();
  }



  void togglePauseResume(BlockGame game) {
    isPaused.value = !isPaused.value;
    if (isPaused.value) {
      game.pauseEngine();
      pauseBgm();
    } else {
      game.resumeEngine();
      resumeBgm();
    }
  }

  @override
  void onClose() {
    stopMoving();
    stopShooting();
    _movePlayer.dispose();
    // _bulletPlayer.dispose();
    FlameAudio.bgm.stop();
    super.onClose();
  }
} 
