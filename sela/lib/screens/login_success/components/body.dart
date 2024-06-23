import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:sela/components/default_button.dart';
import 'package:sela/screens/home/home_screen.dart';
import 'package:sela/size_config.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> with SingleTickerProviderStateMixin {
  // animation controller
  late AnimationController _animationController;

  // init state to create animation controller
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            // Image.asset(
            //   "assets/images/success.png",
            //   height: SizeConfig.screenHeight * 0.4,
            // ),
            // Image.asset(
            //   "assets/images/check2.gif",
            //   height: SizeConfig.screenHeight * 0.4,
            //   scale: 0.2,
            // ),
            Lottie.asset(
              'assets/images/check.json',
              height: SizeConfig.screenHeight * 0.4,
              fit: BoxFit.fill,
              animate: true,
              frameRate: const FrameRate(30),
              repeat: false,
              controller: _animationController,
              onLoaded: (composition) {
                _animationController
                  ..duration = composition.duration
                  ..forward();
              },
            ),
            SizedBox(height: SizeConfig.screenHeight * 0.04),
            Text(
              "Login Success",
              style: TextStyle(
                fontSize: getProportionateScreenWidth(30),
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Spacer(),
            SizedBox(
              width: SizeConfig.screenWidth * 0.6,
              child: DefaultButton(
                text: "Back To Home",
                press: () {
                  Navigator.pushNamed(context, HomeScreen.routeName);
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
