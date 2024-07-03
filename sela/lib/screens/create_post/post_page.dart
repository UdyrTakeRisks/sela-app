import 'package:flutter/material.dart';
import 'package:sela/utils/colors.dart';

import '../../components/coustom_bottom_nav_bar.dart';
import '../../utils/enums.dart';
import 'post_stepper.dart';

class PostPage extends StatelessWidget {
  static String routeName = '/create_post';

  const PostPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: primaryColor.withOpacity(0.8),
        title: const Text(
          'Create Service Post',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PostStepper(),
      bottomNavigationBar:
          const CustomBottomNavBar(selectedMenu: MenuState.createPost),
    );
  }
}
