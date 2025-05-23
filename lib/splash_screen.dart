
import 'package:flutter/material.dart';
import 'block_game.dart';
import 'package:flutter/foundation.dart'; 



class SplashWidget extends StatelessWidget {
  final BlockGame game;

  const SplashWidget({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    late final double screenwidth;
    late final double screenheight;


    if (kIsWeb ) {
       screenwidth = 400;
        screenheight = 680;
    }
    else{
        screenwidth = MediaQuery.sizeOf(context).width;
        screenheight = MediaQuery.sizeOf(context).height;
    }
    return SizedBox.expand(
      child: Container(
        color: Colors.black87,
        child: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Full-screen splash image
              Image.asset(
                'assets/images/splash_screen.png',
                 height: screenheight,
               

                fit:BoxFit.fill,
              ),

              // Positioned transparent button over the "Start" area in the image
              Positioned(
                bottom:  screenheight*0.12, // Adjust to align with your image's start text
                child: SizedBox(
                  width: screenwidth*0.34,
                  height: screenheight*0.08,
                  child: ElevatedButton(
                    onPressed: () {
                      game.startGame();
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: const Color.fromARGB(149, 51, 122, 204),
                      shadowColor: const Color.fromARGB(149, 51, 122, 204),
                      surfaceTintColor: const Color.fromARGB(149, 51, 122, 204),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(""), // Empty text – the image shows the button visually
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
