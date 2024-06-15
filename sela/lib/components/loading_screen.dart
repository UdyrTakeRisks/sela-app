import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sela/size_config.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/images/LoadingAnimation.json',
              height: SizeConfig.screenHeight * 0.4,
              fit: BoxFit.fill,
              animate: true,
              repeat: true,
            ),
          ],
        ),
      ),
    );
  }
}
