import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: AlwaysStoppedAnimation<double>(0.0),
            builder: (context, child) {
              return Lottie.asset(
                'assets/Json/blue-balloon.json', // Replace with the path to your Lottie animation file
                alignment: Alignment.center,

                fit: BoxFit.fitHeight,
                // Replace with the name of your animation
              );
            },
          ),

          Text('Loading in...'),
        ],
      ),
    );
  }
}
