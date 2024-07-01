import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sela/screens/sign_in/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/user_model.dart';
import '../../../utils/env.dart';

class ProfileServices {
  static Future<void> updateProfileField(
      String fieldLabel, String oldValue, String newValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('cookie');
    late Uri url;
    late Map<String, dynamic> body;

    switch (fieldLabel) {
      case 'Name':
        url = Uri.parse('$DOTNET_URL_API_BACKEND/User/update/name');
        body = {'name': newValue};
        break;
      case 'Email':
        url = Uri.parse('$DOTNET_URL_API_BACKEND/User/update/email');
        body = {'email': newValue};
        break;
      case 'Phone Number':
        if (newValue.length != 10) {
          SnackBar(content: Text('Phone number must be 10 digits'));
          throw Exception('Phone number must be 10 digits');
        } else if (!RegExp(r'^[0-9]*$').hasMatch(newValue)) {
          SnackBar(content: Text('Phone number must contain only digits'));
          throw Exception('Phone number must contain only digits');
        }
        url = Uri.parse('$DOTNET_URL_API_BACKEND/User/update/phone');
        body = {'phoneNumber': newValue};
        break;
      case 'Password':
        url = Uri.parse('$DOTNET_URL_API_BACKEND/User/update/password');
        body = {'oldPassword': oldValue, 'newPassword': newValue};
        break;
      // Add more cases for other fields as needed
      default:
        throw Exception('Unsupported field: $fieldLabel');
    }

    print(oldValue);

    print('Updating $fieldLabel to $newValue');

    print('URL: $url');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
        body: jsonEncode(body),
      );

      print('Response: ${response.body}');
      if (response.statusCode == 200) {
        // Handle success, e.g., update local state or notify user
        print('Successfully updated $fieldLabel');
        // Show snackbar or dialog to notify user
        SnackBar(content: Text('Successfully updated $fieldLabel'));
      } else {
        throw Exception('Failed to update $fieldLabel');
      }
    } catch (e) {
      throw Exception('Failed to update $fieldLabel: $e');
    }
  }

  static Future<Users> fetchUserDetails(BuildContext context) async {
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
      return Users.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      // Unauthorized
      await prefs.remove('cookie');
      await prefs.remove('cookieExpirationTimestamp');
      // show snackbar or dialog to notify user
      const SnackBar(content: Text('Unauthorized'));
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const SignInScreen()));
      throw Exception('Unauthorized');
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
