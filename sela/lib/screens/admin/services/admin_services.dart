import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sela/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

import '../models/User.dart'; // Import your User model

class AdminServices {
  // Function to fetch users from API
  static Future<List<User>> fetchUsersFromApi() async {
    final url = Uri.parse(
        '$DOTNET_URL_API_BACKEND_ADMIN/view/users'); // Replace with your API endpoint
    print('fetchUsersFromApi: $url');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie =
          prefs.getString('cookie'); // Retrieve cookie from SharedPreferences

      print('cookie: $cookie');
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse.map((data) => User.fromJson(data)).toList();
      }
      throw Exception('Failed to load users');
    } catch (e) {
      print('Error fetching users: $e');
      throw Exception('Failed to load users');
    }
  }

  // Function to delete user by userId
  static Future<void> deleteUser(int userId) async {
    final url = Uri.parse('$DOTNET_URL_API_BACKEND/Admin/delete/user/$userId');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      print(url);
      print('cookie: $cookie');

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (cookie != null) 'Cookie': cookie,
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        print('User deleted successfully');
      } else if (response.statusCode == 400) {
      } else {
        print(response.statusCode);
        throw Exception('Failed to delete user');
      }
    } catch (e) {
      print('Error deleting user: $e');
      throw Exception('Failed to delete user');
    }
  }
}
