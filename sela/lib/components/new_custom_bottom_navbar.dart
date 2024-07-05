import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sela/screens/create_post/post_page.dart';
import 'package:sela/screens/home/home_screen.dart';
import 'package:sela/screens/my_posts/my_posts_page.dart';
import 'package:sela/screens/notification/notification_page.dart';
import 'package:sela/screens/profile/profile_screen.dart';
import 'package:sela/screens/sign_in/sign_in_screen.dart'; // Import your sign-in screen
import 'package:sela/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../utils/colors.dart';

class MainScreen extends StatefulWidget {
  static String routeName = "/main";

  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  // make a function to check if the user has a cookie

  Future<bool> isCookieValid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? expirationTimestamp = prefs.getString('cookieExpirationTimestamp');
    if (expirationTimestamp == null) {
      return false; // No timestamp means the cookie is not valid
    }
    DateTime expirationDate = DateTime.parse(expirationTimestamp);
    return DateTime.now().isBefore(expirationDate);
  }

  void _onItemTapped(int index) async {
    if (_selectedIndex == index) return;

    // check if the user has a cookie
    bool hasCookie = await isCookieValid();
    if (!hasCookie && index > 0) {
      // User doesn't have a cookie and tries to navigate to other pages
      toastification.showCustom(
        context: context,
        autoCloseDuration: const Duration(seconds: 5),
        alignment: Alignment.topRight,
        builder: (BuildContext context, ToastificationItem holder) {
          return Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: primaryColor.withOpacity(0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: primaryColor.withOpacity(0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Please Sign In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Please create an account to access this feature.',
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Navigate to sign-in screen
                              Navigator.pushNamed(
                                  context, SignInScreen.routeName);
                            },
                            child: const Text('Sign In'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
      return; // Prevent navigation
    }

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
        children: [
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
            icon: Icons.settings_rounded,
            label: 'Settings',
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
