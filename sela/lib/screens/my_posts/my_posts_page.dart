import 'package:flutter/material.dart';

import '../../models/my_post_model.dart';
import 'components/post_card.dart';
import 'components/user_info.dart';
import 'my_posts_service.dart';
import 'my_posts_viewmodel.dart';

class MyPostsPage extends StatefulWidget {
  static String routeName = '/my_posts';
  @override
  _MyPostsPageState createState() => _MyPostsPageState();
}

class _MyPostsPageState extends State<MyPostsPage> {
  final MyPostsViewModel viewModel = MyPostsViewModel(MyPostsService());

  List<MyPost> posts = [];
  @override
  void initState() {
    super.initState();
    viewModel.fetchUserPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Services Posts'),
      ),
      body: Column(
        children: [
          UserInfo(), // Display user info
          Expanded(
            child: ValueListenableBuilder<List<MyPost>>(
              valueListenable: viewModel.postsNotifier,
              builder: (context, posts, _) {
                if (posts.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  return ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      return PostCard(post: posts[index]);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
