import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sela/utils/env.dart'; // Import your environment variables
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/Individual.dart';
import '../../../models/Organizations.dart';
import '../../sign_in/sign_in_screen.dart';
import '../models/User.dart';

class AdminServices {
  static Future<List<User>> fetchUsersFromApi() async {
    final url = Uri.parse('$DOTNET_URL_API_BACKEND_ADMIN/view/users');
    try {
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
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => User.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Failed to load users');
    }
  }

  static Future<void> deleteUser(int userId) async {
    final url =
        Uri.parse('$DOTNET_URL_API_BACKEND/api/Admin/delete/user/$userId');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user');
    }
  }

  static Future<List<Organization>> fetchOrganizations() async {
    final response =
        await http.get(Uri.parse('$DOTNET_URL_API_BACKEND/Post/view/all/orgs'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((org) => Organization.fromJson(org)).toList();
    } else {
      throw Exception('Failed to load organizations');
    }
  }

  static Future<List<Individual>> fetchIndividuals() async {
    final url = Uri.parse('$DOTNET_URL_API_BACKEND/Post/view/all/individuals');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      List<Individual> individuals =
          jsonData.map((item) => Individual.fromJson(item)).toList();
      print('Individuals: $individuals');
      return individuals;
    } else if (response.statusCode == 204 || response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to load individuals');
    }
  }

  static Future<void> deletePost(int postId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs
        .getString('cookie'); // Retrieve the cookie from shared preferences

    if (cookie == null) {
      throw Exception('No cookie found');
    }

    final response = await http.delete(
      Uri.parse('$DOTNET_URL_API_BACKEND/Admin/delete/post/$postId'),
      headers: {
        'Content-Type': 'application/json',
        'Cookie': cookie, // Include the cookie in the headers
      },
    );

    if (response.statusCode == 200) {
      // Successfully deleted
      print('Post deleted successfully');
    } else {
      // Failed to delete
      throw Exception('Failed to delete post');
    }
  }

  static Future<void> logout(BuildContext context) async {
    print('Logging out...');
    var url = Uri.parse('$DOTNET_URL_API_BACKEND_ADMIN/api/Admin/logout');

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs
          .getString('cookie'); // Retrieve the cookie from shared preferences

      if (cookie != null) {
        print('Sending logout request...');
        http.Response response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': cookie,
          },
        );

        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          await prefs.remove('cookie');
          await prefs.remove('cookieExpirationTimestamp');
          Navigator.pushReplacementNamed(context, SignInScreen.routeName);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout Successful')),
          );
          print('Logout successful.');
        } else if (response.statusCode == 401) {
          await prefs.remove('cookie');
          await prefs.remove('cookieExpirationTimestamp');
          Navigator.pushReplacementNamed(context, SignInScreen.routeName);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unauthorized during logout')),
          );
          print('Unauthorized during logout.');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Logout Failed')),
          );
          print('Logout failed.');
          throw Exception('Failed to logout');
        }
      } else {
        Navigator.pushReplacementNamed(context, SignInScreen.routeName);
        print('No cookie found. Redirecting to sign-in screen.');
      }
    } catch (e) {
      _showErrorDialog(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Logout Failed')),
      );
      print('Exception during logout: $e');
    }
  }

  static void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('Failed to logout. Please try again later.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
