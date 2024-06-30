import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';
import '../../../utils/env.dart';

class ProfileServices {
  static Future<User> fetchUserDetails() async {
    final url = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/details');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('cookie');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load user details');
    }
  }

  static Future<String> fetchProfilePhoto() async {
    final url = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/photo');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('cookie');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      },
    );

    if (response.statusCode == 200) {
      return response.body.trim(); // Assuming the response is just the URL
    } else {
      throw Exception('Failed to load profile photo');
    }
  }

  static Future<void> logout(BuildContext context) async {
    var url = Uri.parse('$DOTNET_URL_API_BACKEND/User/logout');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? cookie = prefs.getString('cookie');

      if (cookie != null) {
        http.Response response = await http.post(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': cookie,
          },
        );

        if (response.statusCode == 200) {
          await prefs.remove('cookie');
          await prefs.remove('cookieExpirationTimestamp');
          Navigator.pushReplacementNamed(context, '/sign_in');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logout Successful'),
            ),
          );
        } else if (response.statusCode == 401) {
          await prefs.remove('cookie');
          await prefs.remove('cookieExpirationTimestamp');
          Navigator.pushReplacementNamed(context, '/sign_in');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logout Successful'),
            ),
          );
        } else {
          _showErrorDialog(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Logout Failed'),
            ),
          );
          throw Exception('Failed to logout');
        }
      } else {
        Navigator.pushReplacementNamed(context, '/sign_in');
      }
    } catch (e) {
      _showErrorDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logout Failed'),
        ),
      );
    }
  }

  static void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('An Error Occurred!'),
        content: const Text('Something went wrong. Please try again later.'),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }
}
