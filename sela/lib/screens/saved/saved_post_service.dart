import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/save_post.dart';
import '../../utils/env.dart';

class SavedPostService {
  Future<List<SavedPost>> fetchSavedPosts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      final url = Uri.parse('$DOTNET_URL_API_BACKEND/Post/view/saved');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      });

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        List<SavedPost> savedPosts =
            jsonData.map((item) => SavedPost.fromJson(item)).toList();

        print(savedPosts);

        return savedPosts;
      } else {
        print('Failed to load saved posts');
        print(response.body);
        print(response.statusCode);
        throw Exception('Failed to load saved posts');
      }
    } catch (e) {
      print('Error fetching saved posts: $e');
      return []; // Return empty list on error
    }
  }
}
