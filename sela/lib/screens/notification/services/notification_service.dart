import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/env.dart';

class NotificationService {
  static Future<List<String>> fetchOldNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cookie = prefs.getString('cookie');

    // Replace with actual API URL
    const String url = '$DOTNET_URL_API_BACKEND/Notification/show/all';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': cookie ?? '', // Include the cookie if available
        },
      );

      if (response.statusCode == 200) {
        // Parse JSON response and extract notifications
        List<dynamic> data = jsonDecode(response.body);
        List<String> notifications = data.map((item) {
          return item['message'].toString();
        }).toList();
        return notifications;
      } else if (response.statusCode == 400) {
        return [response.body];
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden');
      } else if (response.statusCode == 404) {
        return [response.body];
      } else {
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      print('Error fetching notifications: $e');
      throw Exception('Failed to load notifications');
    }
  }

  static Future<List<String>> fetchNewNotifications() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cookie = prefs.getString('cookie');

    // Replace with actual API URL
    const String url =
        '$DOTNET_URL_API_BACKEND/Notification/receive/welcome-msg';

    print(cookie);

    try {
      String notification;
      String notificationAddToDatabase;

      // Fetch new notifications from the queue
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': cookie ?? '', // Include the cookie if available
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        // If the response is a plain text message, add it to the list
        notification = response.body;
      } else if (response.statusCode == 400) {
        throw Exception('Bad request');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden');
      } else if (response.statusCode == 404) {
        return [response.body];
      } else {
        throw Exception('Failed to load new notifications');
      }

      notificationAddToDatabase = await addNotification(notification);
      print('New notifications: $notification');
      return [notification];
    } catch (e) {
      print('Error fetching new notifications: $e');
      throw Exception('Failed to load new notifications');
    }
  }

  static Future<String> addNotification(String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cookie = prefs.getString('cookie');

    // Replace with actual API URL
    const String url = '$DOTNET_URL_API_BACKEND/Notification/add';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': cookie ?? '', // Include the cookie if available
        },
        body: jsonEncode(<String, String>{
          'message': message,
        }),
      );
      print(response.body);
      if (response.statusCode == 200) {
        print('Notification added successfully');
        return response.body;
      } else if (response.statusCode == 400) {
        throw Exception('Bad request');
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      } else if (response.statusCode == 403) {
        throw Exception('Forbidden');
      } else if (response.statusCode == 404) {
        throw Exception('Notification not found');
      } else {
        throw Exception('Failed to add notification');
      }
    } catch (e) {
      print('Error adding notification: $e');
      throw Exception('Failed to add notification');
    }
  }
}
