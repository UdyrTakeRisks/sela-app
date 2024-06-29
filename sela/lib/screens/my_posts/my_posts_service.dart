import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/my_post_model.dart';
import '../../utils/env.dart';

class MyPostsData {
  final String username;
  final List<MyPost> posts;

  MyPostsData({required this.username, required this.posts});
}

class MyPostsService {
  Future<MyPostsData> fetchUserPosts() async {
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
        Map<String, dynamic> responseData = jsonDecode(response.body);
        List<dynamic> postsJson = responseData['posts'];
        String username = responseData['username'];
        List<MyPost> posts =
            postsJson.map((json) => MyPost.fromJson(json)).toList();

        print('username: ' + username);

        print('posts count: ' + posts.length.toString());

        // Print the imageUrls from the first post for debugging
        if (posts.isNotEmpty) {
          print('imagesUrls: ' + posts[0].imageUrls.toString());
        }

        return MyPostsData(username: username, posts: posts);
      } else {
        return MyPostsData(
            username: '', posts: []); // Return empty data if no posts are found
      }
    } else {
      throw Exception('Failed to load posts');
    }
  }
}
