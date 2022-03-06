import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pingpong/ball.dart';
import 'package:pingpong/brick.dart';
import 'package:pingpong/coverscreen.dart';

class HomePage extends StatefulWidget {

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
   bool gameHaStarted=false;
   double ballX=0;
   double ballY=0;

  startGame(){
     gameHaStarted=true;
    Timer.periodic(Duration(milliseconds:1), (timer) {

      setState(() {
        ballY+=0.01;
              
            });
      
     });
   

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: startGame,
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        body: Center(
          child: Stack(
            children: [
              CoverScreen(
                gameHasStarted: gameHaStarted,
                //finished 9
                //gameHaStarted:gameHaStarted
              ),
              
             //upper brick starts here
             MyBrick(x:0,y:-0.9),

          
             //lower brick
              MyBrick(x:0,y:0.9),
              
              //ball
              MyBall(
                x: ballX,
                y:ballY,
              )
            ],
          ),
        ),

        
        
      ),
    );
  }
}