import 'package:flutter/material.dart';

import 'components/body.dart';

class CompleteProfileScreen extends StatelessWidget {
  static String routeName = "/complete_profile";

  const CompleteProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String email = arguments['email'];
    final String password = arguments['password'];

    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: Body(email: email, password: password));
  }
}
