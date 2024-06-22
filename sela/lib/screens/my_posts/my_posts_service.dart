import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/my_post_model.dart';
import '../../utils/env.dart';

class MyPostsService {
  Future<List<MyPost>> fetchUserPosts() async {
    final url = Uri.parse('$DOTNET_URL_API_BACKEND/Post/myPosts');
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
      // Check if response body is not null
      if (response.body != null && response.body.isNotEmpty) {
        List<dynamic> postsJson = jsonDecode(response.body);
        return postsJson.map((json) => MyPost.fromJson(json)).toList();
      } else {
        return []; // Return empty list if no posts are found
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
