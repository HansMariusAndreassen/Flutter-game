import 'package:flutter/material.dart';
import "ball.dart";
import 'paddle.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  double paddlePositionX = 0.0;
  double paddleWidth = 80;
  double paddleHeight = 20.0;
  double ballDiameter = 10.0;
  double ballX = 0.0;
  double ballY = 0.0;
  double ballVelocityX = 2.0;
  double ballVelocityY = 2.0;
  late AnimationController controller;
  int hitCount = 0;
  bool gameStarted = false;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(minutes: 5),
      vsync: this,
    )..addListener(() {
        if (gameStarted) {
          setState(() {
            updateBallPosition();
          });
        }
      });
  }

  void startGame() {
    setState(() {
      gameStarted = true;
      ballX = MediaQuery.of(context).size.width / 2;
      ballY = 50;
      ballVelocityX = 2.0;
      ballVelocityY = 2.0;
      hitCount = 0;
      controller.repeat();
    });
  }

  void updateBallPosition() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    ballX += ballVelocityX;
    ballY += ballVelocityY;

    if (ballX <= 0 || ballX >= screenWidth - ballDiameter) {
      ballVelocityX = -ballVelocityX;
    }

    if (ballY <= 0) {
      ballVelocityY = -ballVelocityY;
    }

    if (ballY + ballDiameter > screenHeight - paddleHeight - 10 &&
        ballX >= paddlePositionX &&
        ballX <= paddlePositionX + paddleWidth) {
      ballVelocityY = -ballVelocityY * 1.1;
      ballVelocityX *= 1.05;
      ballY = screenHeight - paddleHeight - ballDiameter - 10;
      hitCount++;
    }

    if (ballY > screenHeight) {
      gameStarted = false;
      controller.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (gameStarted) {
                setState(() {
                  paddlePositionX += details.delta.dx;
                  paddlePositionX =
                      paddlePositionX.clamp(0, screenWidth - paddleWidth);
                });
              }
            },
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: ballY,
                  left: ballX,
                  child: const Ball(),
                ),
                Positioned(
                  bottom: 0,
                  left: paddlePositionX,
                  child: Paddle(
                    position: paddlePositionX,
                    width: paddleWidth,
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Opacity(
              opacity: 0.75,
              child: Text(
                '$hitCount',
                style: const TextStyle(fontSize: 124, color: Colors.black),
              ),
            ),
          ),
          if (!gameStarted)
            Positioned(
              top: screenHeight * 0.6,
              child: Container(
                width: screenWidth,
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[300]!,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                  ),
                  onPressed: startGame,
                  child: const Text(
                    "Start",
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
