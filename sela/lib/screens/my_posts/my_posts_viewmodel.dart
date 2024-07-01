import 'package:flutter/foundation.dart';

import 'my_posts_service.dart';

class MyPostsViewModel {
  final MyPostsService service;
  final ValueNotifier<MyPostsData> postsNotifier =
      ValueNotifier(MyPostsData(username: '', posts: []));
  final ValueNotifier<String> photoNotifier = ValueNotifier('');

  MyPostsViewModel(this.service);

  Future<void> fetchUserPosts() async {
    try {
      MyPostsData data = await service.fetchUserPosts();
      postsNotifier.value = data;
      print('Fetched user posts successfully');
    } catch (e) {
      print('Failed to fetch user posts: $e');
    }
  }

  Future<void> fetchPhoto() async {
    try {
      String photoUrl = await service.fetchPhoto();
      photoNotifier.value = photoUrl;
      print('Fetched photo successfully: $photoUrl');
    } catch (e) {
      print('Failed to fetch photo: $e');
    }
  }
}
