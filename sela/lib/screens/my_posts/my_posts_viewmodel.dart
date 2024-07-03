import 'package:flutter/foundation.dart';

import 'my_posts_service.dart';

class MyPostsViewModel {
  final MyPostsService service;
  final ValueNotifier<MyPostsData> postsNotifier =
      ValueNotifier(MyPostsData(username: '', posts: []));
  final ValueNotifier<String> photoNotifier = ValueNotifier('');
  final ValueNotifier<int> postCountNotifier =
      ValueNotifier(0); // Add post count notifier

  MyPostsViewModel(this.service);

  Future<void> fetchUserPosts() async {
    try {
      MyPostsData data = await service.fetchUserPosts();
      postsNotifier.value = data;
      updatePostCount(
          data.posts.length); // Update post count after fetching posts
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

  Future<String> fetchUserName() async {
    try {
      String userName = await service.fetchUserName();
      print('Fetched user name successfully: $userName');
      return userName;
    } catch (e) {
      print('Failed to fetch user name: $e');
      return '';
    }
  }

  void updatePostCount(int count) {
    postCountNotifier.value = count;
  }
}
