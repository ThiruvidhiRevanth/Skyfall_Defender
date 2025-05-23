import 'package:flame/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flame/game.dart';
import 'package:window_manager/window_manager.dart';
import 'package:universal_html/html.dart' as html;
import 'splash_screen.dart';
import 'block_game.dart';
import 'game_controller.dart';
import 'package:flutter/foundation.dart'; 
import 'dart:ui';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.macOS ||
          defaultTargetPlatform == TargetPlatform.linux)) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(400, 710),
      center: true,
      backgroundColor: Colors.black,
      skipTaskbar: false,
      title: 'Skyfall Defender',
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(const Main());
}

// Detect mobile browser via user agent
bool _isMobileBrowser() {
  final userAgent = html.window.navigator.userAgent.toLowerCase();
  return userAgent.contains('mobile') ||
      userAgent.contains('android') ||
      userAgent.contains('iphone') ||
      userAgent.contains('ipad');
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
    Get.put(GameController());
  }

  @override
  Widget build(BuildContext context) {
    final isWeb = kIsWeb;
    final isMobileWeb = isWeb && _isMobileBrowser();
    final isDesktop = !isWeb &&
        (defaultTargetPlatform == TargetPlatform.windows ||
            defaultTargetPlatform == TargetPlatform.macOS ||
            defaultTargetPlatform == TargetPlatform.linux);

    

    final size = (isDesktop || (isWeb && !isMobileWeb))
        ? const Size(400, 680)
        : MediaQuery.of(context).size;

    final controller = Get.find<GameController>();
    controller.setScreenSize(width: size.width, height: size.height);
    final blockGame = BlockGame(size);

    return GetMaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            
            (isWeb && !isMobileWeb)
             
               ? Center(
  child: Stack(
    children: [
      // Container(
      //   color:  const Color.fromARGB(255, 62, 120, 187)
      // ),
      
      Positioned.fill(
       
        child: Image.asset(
          'assets/images/appicon.png', // <-- Replace with your image path
          fit: BoxFit.fill,
          height: size.height,
          width: size.width,
           
        ),
      ),
      // Blur filter
      Positioned.fill(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0), // Adjust blur strength
          child: Container(
            color: Colors.black.withOpacity(0.2), // Optional dark overlay
          ),
        ),
      ),
      // Game UI
      Center(
        child: Container(
          width: 400,
          height: 680,
          child: GameWidget(
            game: blockGame,
            initialActiveOverlays: const ['Splash'],
            overlayBuilderMap: _buildOverlayMap(
                size, controller, blockGame, isMobileWeb),
          ),
        ),
      ),
    ],
  ),
)
                : GameWidget(
                    game: blockGame,
                    initialActiveOverlays: const ['Splash'],
                    overlayBuilderMap: _buildOverlayMap(
                        size, controller, blockGame, isMobileWeb),
                  ),
          ],
        ),
      ),
    );
  }

  Map<String, Widget Function(BuildContext, Game)> _buildOverlayMap(
    Size size,
    GameController controller,
    BlockGame blockGame,
    bool isMobileWeb,
  ) {
    final isTouchControls = kIsWeb
        ? isMobileWeb
        : (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    return {
      'Splash': (_, game) => SplashWidget(game: game as BlockGame),
      'GameOver': (context, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Game Over',
                    style: TextStyle(fontSize: 32, color: Colors.red)),
                ElevatedButton(
                  onPressed: () {
                    blockGame.overlays.remove('GameOver');
                    blockGame.resetGame();
                  },
                  child: const Text('Restart'),
                ),
              ],
            ),
          ),
      'GameControls': (_, game) => isTouchControls
          ? Stack(
              children: [
                Positioned(
                  top: size.width * 0.1,
                  right: size.height * 0.05,
                  child: Obx(() => IconButton(
                        icon: Icon(
                          controller.isPaused.value
                              ? Icons.play_arrow
                              : Icons.pause,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.togglePauseResume(blockGame);
                        },
                      )),
                ),
                Align(
                  alignment: const Alignment(0.1, 0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTapDown: (_) => controller.startMovingLeft(),
                        onTapUp: (_) => controller.stopMoving(),
                        onTapCancel: () => controller.stopMoving(),
                        child: ElevatedButton(
                          onPressed: () => controller.moveLeft(),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Icon(Icons.arrow_left),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTapDown: (_) => controller.startMovingRight(),
                        onTapUp: (_) => controller.stopMoving(),
                        onTapCancel: () => controller.stopMoving(),
                        child: ElevatedButton(
                          onPressed: () => controller.moveRight(),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Icon(Icons.arrow_right),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: const Alignment(1.0, 0.7),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 200),
                      GestureDetector(
                        onTapDown: (_) => controller.startshoot(blockGame),
                        onTapUp: (_) => controller.stopShooting(),
                        onTapCancel: () => controller.stopShooting(),
                        child: ElevatedButton(
                          onPressed: () =>
                              controller.shoot(blockGame, noSound: false),
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: Colors.blue,
                          ),
                          child: const Icon(Icons.arrow_upward),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const SizedBox.shrink(),
    };
  }
}
