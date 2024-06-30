import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/env.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // Function to handle the logout button
  Future<void> _logout() async {
    var url = Uri.parse('$DOTNET_URL_API_BACKEND/User/logout');

    try {
      // Retrieve the saved cookie
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? cookie = prefs.getString('cookie');

      if (cookie != null) {
        // Make the logout request
        http.Response response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': cookie,
          },
        );

        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        print('Response headers: ${response.headers}');

        if (response.statusCode == 200) {
          print('Logout successful');
          // Remove the saved cookie
          await prefs.remove('cookie');
          await prefs.remove('cookieExpirationTimestamp');
          print('Cookie removed');

          // Navigate to the login screen
          Navigator.pushReplacementNamed(context, '/sign_in');
          // Show a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logout Successful'),
            ),
          );
        } else if (response.statusCode == 401) {
          print('You already logged out. Redirecting to login screen');
          // Remove the saved cookie
          await prefs.remove('cookie');
          await prefs.remove('cookieExpirationTimestamp');
          print('Cookie removed');

          // Navigate to the login screen
          Navigator.pushReplacementNamed(context, '/sign_in');
          // Show a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logout Successful'),
            ),
          );
        } else {
          _showErrorDialog();
          // Show a Snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logout Failed'),
            ),
          );
          throw Exception('Failed to logout');
        }
      } else {
        print('No cookie found, redirecting to login');
        Navigator.pushReplacementNamed(context, '/sign_in');
      }
    } catch (e) {
      _showErrorDialog();
      // Show a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout Failed'),
        ),
      );
      print(e.toString());
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('An Error Occurred!'),
        content: Text('Something went wrong. Please try again later.'),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          ProfilePic(),
          SizedBox(height: 20),
          ProfileMenu(
            text: "My Account",
            icon: "assets/icons/User Icon.svg",
            press: () => {},
          ),
          ProfileMenu(
            text: "Notifications",
            icon: "assets/icons/Bell.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Settings",
            icon: "assets/icons/Settings.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Help Center",
            icon: "assets/icons/Question mark.svg",
            press: () {},
          ),
          ProfileMenu(
            text: "Log Out",
            icon: "assets/icons/Log out.svg",
            press: _logout,
          ),
        ],
      ),
    );
  }
}
