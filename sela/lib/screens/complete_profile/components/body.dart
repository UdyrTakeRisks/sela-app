import 'package:flutter/material.dart';

import '../../../utils/constants.dart';
import 'complete_profile_form.dart';

class Body extends StatelessWidget {
  final String email;
  final String password;

  const Body({required this.email, required this.password, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Text("Complete Profile", style: headingStyle),
                const Text(
                  "Complete your details or continue  \nwith social media",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CompleteProfileForm(email: email, password: password),
                const SizedBox(height: 30),
                Text(
                  "By continuing your confirm that you agree \nwith our Term and Condition",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
