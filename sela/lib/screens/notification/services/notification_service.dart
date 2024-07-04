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
      List<String> notifications = [];
      List<String> NotificationToDatabase = [];
      while (true) {
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
          notifications.add(response.body);
        } else if (response.statusCode == 400) {
          // Stop fetching when the queue returns a 400 response code
          break;
        } else if (response.statusCode == 401) {
          throw Exception('Unauthorized');
        } else if (response.statusCode == 403) {
          throw Exception('Forbidden');
        } else if (response.statusCode == 404) {
          print('No new notifications found');
          break;
        } else {
          throw Exception('Failed to load new notifications');
        }
      }
      NotificationToDatabase = await addNotification(notifications);
      print('New notifications: $notifications');
      return notifications;
    } catch (e) {
      print('Error fetching new notifications: $e');
      throw Exception('Failed to load new notifications');
    }
  }

  static Future<List<String>> addNotification(List<String> message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? cookie = prefs.getString('cookie');

    // Replace with actual API URL
    const String url = '$DOTNET_URL_API_BACKEND/Notification/add';

    List<String> notificationsAddList = [];
    try {
      for (String msg in message) {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Cookie': cookie ?? '', // Include the cookie if available
          },
          body: jsonEncode(<String, String>{
            'message': msg,
          }),
        );

        if (response.statusCode == 200) {
          notificationsAddList.add(response.body);
        } else if (response.statusCode == 401) {
          throw Exception('Unauthorized');
        } else if (response.statusCode == 403) {
          throw Exception('Forbidden');
        } else if (response.statusCode == 404) {
          throw Exception('Notification not found');
        } else {
          throw Exception('Failed to add notification');
        }
      }
      print('Added notifications: $notificationsAddList');
      return notificationsAddList;
    } catch (e) {
      print('Error adding notification: $e');
      throw Exception('Failed to add notification');
    }
  }
}
