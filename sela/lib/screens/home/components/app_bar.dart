import 'package:flutter/material.dart';

import '../../profile/profile_screen.dart';

class AppBarWelcome extends StatelessWidget {
  const AppBarWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // i want padding on the left and top side of the app bar
      padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SELA",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: "poppins",
                ),
              ),
              Text(
                "Welcome Back!👋",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF95969D),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(
                      "assets/images/profile.png"), // Adjust the path as necessary
                ),
                Positioned(
                  top: 1,
                  right: 1,
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
