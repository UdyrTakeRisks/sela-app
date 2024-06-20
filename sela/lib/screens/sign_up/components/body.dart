import 'package:flutter/material.dart';
import 'package:sela/size_config.dart';

import '../../../components/social_card.dart';
import '../../../utils/constants.dart';
import 'sign_up_form.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                  height: SizeConfig.screenHeight * 0.02), // 2% of total height
              Text("Register Account", style: headingStyle),
              const Text(
                  "Complete your details or continue \nwith social media",
                  textAlign: TextAlign.center),
              SizedBox(
                  height: SizeConfig.screenHeight * 0.07), // 7% of total height
              SignUpForm(),
              SizedBox(
                  height: SizeConfig.screenHeight * 0.07), // 7% of total height
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialCard(
                    icon: "assets/icons/google-icon.svg",
                    press: () {},
                  ),
                  SocialCard(
                    icon: "assets/icons/facebook-2.svg",
                    press: () {},
                  ),
                  SocialCard(
                    icon: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                ],
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              Text(
                'By continuing your confirm that you agree \nwith our Term and Condition',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
