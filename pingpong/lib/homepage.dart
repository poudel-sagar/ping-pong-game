import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pingpong/ball.dart';
import 'package:pingpong/brick.dart';
import 'package:pingpong/coverscreen.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

enum direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  double playerX = -0.2;
  double brickWidth = 0.4;
  double enemyX= -0.2;
  bool gameHaStarted = false;
  double ballX = 0;
  double ballY = 0;
  var ballYDirection = direction.DOWN;
  var ballXDirection = direction.LEFT;

  startGame() {
    gameHaStarted = true;
    Timer.periodic(Duration(milliseconds: 1), (timer) {
      //update direction
      updateDirection();
//move ball
      moveBall();

      moveEnemy();
//check if player is dead
      if (isPlayerDead()) {
        timer.cancel();
        _showDialog();
      }
    });
  }

  moveEnemy(){
    setState(() {
          enemyX = ballX;
        });
  }

  void _showDialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.deepPurple,
            title: Center(
              child: Text(
                "purple win",
                style: TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: resetGame,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    padding: EdgeInsets.all(7),
                    color: Colors.deepPurple[100],
                    child: Text(
                      "play again",
                      style: TextStyle(color: Colors.deepPurple[800]),
                    ),
                  ),
                ),
              )
            ],
          );
        });
  }

  void resetGame() {
    Navigator.pop(context);
    setState(() {
      gameHaStarted = false;
      ballX = 0;
      ballY = 0;
      playerX = -0.2;
    });
  }

  bool isPlayerDead() {
    if (ballY >= 1) {
      return true;
    }
    return false;
  }

  void updateDirection() {
    setState(() {
      //updatevertical direction
      if (ballY >= 0.9 && playerX + brickWidth >= ballX && playerX <= ballX) {
        ballYDirection = direction.UP;
      } else if (ballY <= -0.9) {
        ballYDirection = direction.DOWN;
      }
      //update horizontal direction
      if (ballX >= 1) {
        ballYDirection = direction.LEFT;
      } else if (ballX <= -1) {
        ballYDirection = direction.DOWN;
      }
    });
  }

  void moveBall() {
    setState(() {
      //vertical movement
      if (ballYDirection == direction.DOWN) {
        ballY += 0.01;
      } else if (ballYDirection == direction.UP) {
        ballX -= 0.01;
      }

      //horizontal movement
      if (ballXDirection == direction.LEFT) {
        ballX -= 0.01;
      } else if (ballXDirection == direction.RIGHT) {
        ballX += 0.01;
      }
    });
  }

  void moveLeft() {
    setState(() {
      playerX -= 0.1;
    });
  }

  void moveRight() {
    setState(() {
      playerX += 0.1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
          moveLeft();
        } else if (event.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
          moveRight();
        }
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          body: Center(
            child: Stack(
              children: [
                CoverScreen(
                  gameHasStarted: gameHaStarted,

                  //gameHaStarted:gameHaStarted
                ),

                //upper brick starts here
                MyBrick(x: enemyX, y: -0.9, brickWidth: brickWidth),

                //lower brick
                MyBrick(x: playerX, y: 0.9, brickWidth: brickWidth),

                //ball
                MyBall(
                  x: ballX,
                  y: ballY,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
