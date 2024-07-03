import 'package:flutter/material.dart';
import 'package:sela/screens/create_post/post_page.dart';
import 'package:sela/screens/home/home_screen.dart';
import 'package:sela/screens/my_posts/my_posts_page.dart';
import 'package:sela/screens/notification/notification_page.dart';
import 'package:sela/screens/profile/profile_screen.dart';
import 'package:sela/utils/constants.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/main";

  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onItemTapped(int index) {
    if (_selectedIndex == index) return;
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: const [
          HomeScreen(),
          MyPostsPage(),
          PostPage(),
          NotificationPage(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 18,
      ), // Adjust bottom padding as needed
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconColumn(
            icon: Icons.home_rounded,
            label: 'Home',
            selected: _selectedIndex == 0,
            index: 0,
          ),
          _buildIconColumn(
            icon: Icons.my_library_books_outlined,
            label: 'My Posts',
            selected: _selectedIndex == 1,
            index: 1,
          ),
          _buildIconColumn(
            icon: Icons.add_box,
            label: 'Post',
            selected: _selectedIndex == 2,
            index: 2,
          ),
          _buildIconColumn(
            icon: Icons.notifications_active_outlined,
            label: 'Notifications',
            selected: _selectedIndex == 3,
            index: 3,
          ),
          _buildIconColumn(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            selected: _selectedIndex == 4,
            index: 4,
          ),
        ],
      ),
    );
  }

  Column _buildIconColumn({
    required IconData icon,
    required String label,
    required bool selected,
    required int index,
  }) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);
    const selectedIndicatorHeight = 2.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: selected ? kPrimaryColor : inActiveIconColor,
          ),
          onPressed: () => _onItemTapped(index),
        ),
        Stack(
          children: [
            Text(
              label,
              style: TextStyle(
                color: selected ? kPrimaryColor : inActiveIconColor,
                fontSize: 12,
              ),
            ),
            if (selected)
              Positioned(
                left: 0,
                right: 0,
                top: 16,
                height: 1,
                child: Container(
                  color: kPrimaryColor, // Adjust color as needed
                ),
              ),
          ],
        ),
      ],
    );
  }
}
