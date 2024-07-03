import 'package:flutter/material.dart';

import '../../models/my_post_model.dart';
import 'components/post_card.dart';
import 'components/user_info.dart';
import 'my_posts_service.dart';
import 'my_posts_viewmodel.dart';

class MyPostsPage extends StatefulWidget {
  static String routeName = '/my_posts';

  const MyPostsPage({super.key});
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
    viewModel.fetchPhoto(); // Fetch photo on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Posts'),
        scrolledUnderElevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await viewModel.fetchUserPosts();
          await viewModel.fetchPhoto(); // Fetch photo on refresh
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              ValueListenableBuilder<MyPostsData>(
                valueListenable: viewModel.postsNotifier,
                builder: (context, data, _) {
                  if (data.username.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ValueListenableBuilder<String>(
                      valueListenable: viewModel.photoNotifier,
                      builder: (context, photoUrl, _) {
                        return UserInfo(
                          userName: data.username,
                          userImage: photoUrl,
                        );
                      },
                    );
                  }
                },
              ), // Display user info
              Expanded(
                child: ValueListenableBuilder<MyPostsData>(
                  valueListenable: viewModel.postsNotifier,
                  builder: (context, data, _) {
                    if (data.posts.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.builder(
                        itemCount: data.posts.length,
                        itemBuilder: (context, index) {
                          return PostCard(
                            post: data.posts[index],
                            onDelete: () async {
                              await viewModel.fetchUserPosts();
                            },
                            onEdit: () async {
                              await viewModel.fetchUserPosts();
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar:
      //     const CustomBottomNavBar(selectedMenu: MenuState.myPosts),
    );
  }
}
