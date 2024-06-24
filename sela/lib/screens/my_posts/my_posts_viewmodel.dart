import 'package:flutter/foundation.dart';
import 'package:sela/models/my_post_model.dart';

import 'my_posts_service.dart';

class MyPostsViewModel {
  final MyPostsService service;
  final ValueNotifier<List<MyPost>> postsNotifier = ValueNotifier([]);

  MyPostsViewModel(this.service);

  Future<void> fetchUserPosts() async {
    try {
      List<MyPost> posts = await service.fetchUserPosts();
      postsNotifier.value = posts;
    } catch (e) {
      print('Failed to fetch user posts: $e');
    }
  }
}
