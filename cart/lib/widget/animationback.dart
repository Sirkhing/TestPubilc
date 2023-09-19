import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/Json/flower.json', // Replace with the path to your Lottie animation file
      alignment: Alignment.center,
      fit: BoxFit.cover,
       // Replace with the name of your animation
    );
  }
}
class cartBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/Json/packaging-for-delivery.json', // Replace with the path to your Lottie animation file
        alignment: Alignment.center,

        fit: BoxFit.fitHeight,
        // Replace with the name of your animation
      ),
    );
  }
}
class drawerBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/Json/animation_lmlh0i9i.json', // Replace with the path to your Lottie animation file
        alignment: Alignment.center,

        fit: BoxFit.fitHeight,
        // Replace with the name of your animation
      ),
    );
  }
}
class background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/Json/raining.json', // Replace with the path to your Lottie animation file
        alignment: Alignment.center,

        fit: BoxFit.fitHeight,
        // Replace with the name of your animation
      ),
    );
  }
}
