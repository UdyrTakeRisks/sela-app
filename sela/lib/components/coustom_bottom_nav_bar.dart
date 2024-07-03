import 'package:flutter/material.dart';
import 'package:sela/screens/create_post/post_page.dart';
import 'package:sela/screens/home/home_screen.dart';
import 'package:sela/screens/my_posts/my_posts_page.dart';
import 'package:sela/screens/notification/notification_page.dart';
import 'package:sela/screens/profile/profile_screen.dart';
import 'package:sela/utils/constants.dart';
import 'package:sela/utils/enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.selectedMenu,
  });

  final MenuState selectedMenu;

  @override
  Widget build(BuildContext context) {
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
              menuState: MenuState.home,
              routeName: HomeScreen.routeName,
            ),
            buildIconColumn(
              context,
              icon: Icons.my_library_books_outlined,
              label: 'My Posts',
              selected: MenuState.myPosts == selectedMenu,
              menuState: MenuState.myPosts,
              routeName: MyPostsPage.routeName,
            ),
            buildIconColumn(
              context,
              icon: Icons.add_box,
              label: 'Post',
              selected: MenuState.add == selectedMenu,
              menuState: MenuState.add,
              routeName: PostPage.routeName,
            ),
            buildIconColumn(
              context,
              icon: Icons.notifications_active_outlined,
              label: 'Notifications',
              selected: MenuState.notification == selectedMenu,
              menuState: MenuState.notification,
              routeName: NotificationPage.routeName,
            ),
            buildIconColumn(
              context,
              icon: Icons.person_outline_rounded,
              label: 'Profile',
              selected: MenuState.profile == selectedMenu,
              menuState: MenuState.profile,
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
    required MenuState menuState,
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
          onPressed: () {
            if (selected) return; // Do nothing if the current page is selected
            Navigator.pushReplacementNamed(context, routeName);
          },
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
