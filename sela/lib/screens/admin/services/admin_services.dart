import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:sela/utils/env.dart'; // Import your environment variables
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/Individual.dart';
import '../../../models/Organizations.dart';
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
}
