import 'package:flutter/material.dart';

import 'post_stepper.dart';

class PostPage extends StatelessWidget {
  static String routeName = '/post';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Service Post'),
      ),
      body: PostStepper(),
    );
  }
}
