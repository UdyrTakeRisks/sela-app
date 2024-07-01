// lib/services/rating_service.dart

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/env.dart';

class RatingService {
  Future<double> fetchRating(int postId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      final url = Uri.parse(
          '$DOTNET_URL_API_BACKEND/Post/view/overall/rating?postId=$postId');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      });

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data['overallRating'].toDouble();
      } else {
        print('Failed to load rating');
        throw Exception('Failed to load rating');
      }
    } catch (e) {
      print('Error fetching rating: $e');
      return 0.0;
    }
  }
}
