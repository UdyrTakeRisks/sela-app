import 'package:flutter/material.dart';
import 'package:sela/screens/my_posts/my_posts_page.dart';

import '../screens/create_post/post_page.dart';
import '../screens/home/home_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/saved/saved_screen.dart';
import '../utils/constants.dart';
import '../utils/enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedMenu,
  });

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.6),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildIconColumn(
              context,
              icon: Icons.home_rounded,
              label: 'Home',
              selected: MenuState.home == selectedMenu,
              routeName: HomeScreen.routeName,
            ),
            buildIconColumn(
              context,
              icon: Icons.my_library_books_outlined,
              label: 'My Posts',
              selected: MenuState.myPosts == selectedMenu,
              routeName: MyPostsPage.routeName,
            ),
            buildIconColumn(
              context,
              icon: Icons.add_box,
              label: 'Post',
              selected: MenuState.add == selectedMenu,
              routeName: PostPage.routeName,
            ),
            buildIconColumn(
              context,
              icon: Icons.bookmark_add_outlined,
              label: 'Saved',
              selected: MenuState.bookmark == selectedMenu,
              routeName: SavedScreen.routeName,
            ),
            buildIconColumn(
              context,
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              selected: MenuState.profile == selectedMenu,
              routeName: ProfileScreen.routeName,
            ),
          ],
        ),
      ),
    );
  }

  Column buildIconColumn(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool selected,
    required String routeName,
  }) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: selected ? kPrimaryColor : inActiveIconColor,
          ),
          onPressed: () => Navigator.pushNamed(context, routeName),
        ),
        Text(
          label,
          style: TextStyle(
            color: selected ? kPrimaryColor : inActiveIconColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
