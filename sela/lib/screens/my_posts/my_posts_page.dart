import 'package:flutter/material.dart';
import 'package:sela/utils/colors.dart';

import '../../models/Organizations.dart';
import '../../models/my_post_model.dart';
import '../details/details_screen.dart';
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
  String _userName = ''; // Initialize userName

  @override
  void initState() {
    super.initState();
    fetchData(); // Fetch initial data including user name
  }

  Future<void> fetchData() async {
    setState(() {
      _userName = 'Loading...'; // Set loading state for userName
    });

    try {
      final String userName =
          await viewModel.fetchUserName(); // Fetch user name

      setState(() {
        _userName = userName; // Update userName with fetched value
      });

      await viewModel.fetchUserPosts(); // Fetch user posts
      await viewModel.fetchPhoto(); // Fetch user photo
    } catch (e) {
      print('Failed to fetch data: $e');
      setState(() {
        _userName = ''; // Reset userName on error
      });
      // Handle error as needed (e.g., show error message to user)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('My Posts'),
        scrolledUnderElevation: 0,
        actions: [
          // Display post count with icon in the app bar
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: ValueListenableBuilder<int>(
              valueListenable: viewModel.postCountNotifier,
              builder: (context, count, _) {
                return Row(
                  children: [
                    Text(
                      '$count',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ), // Display post count
                    const SizedBox(
                        width: 4), // Add spacing between count and icon
                    const Icon(
                      Icons.card_giftcard,
                      size: 34,
                    ), // Example icon
                  ],
                );
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchData();
        },
        color: primaryColor,
        backgroundColor: backgroundColor4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<String>(
                valueListenable: viewModel.photoNotifier,
                builder: (context, photoUrl, _) {
                  return UserInfo(
                    userName: _userName,
                    userImage: photoUrl,
                  );
                },
              ), // Display user info
              const SizedBox(height: 8),
              Expanded(
                child: ValueListenableBuilder<MyPostsData>(
                  valueListenable: viewModel.postsNotifier,
                  builder: (context, data, _) {
                    if (data.posts.isEmpty) {
                      return const Center(
                          child: Text('You have no posts yet.'));
                    } else {
                      return ListView.builder(
                        itemCount: data.posts.length,
                        itemBuilder: (context, index) {
                          Organization organization =
                              mapMyPostToOrganization(data.posts[index]);
                          return GestureDetector(
                            onTap: () {
                              // Navigate to post details page
                              Navigator.pushNamed(
                                context,
                                DetailsScreen.routeName,
                                arguments: DetailsArguments(
                                  organization: organization,
                                  index: index,
                                ),
                              );
                            },
                            child: PostCard(
                              post: data.posts[index],
                              onDelete: () async {
                                await viewModel.fetchUserPosts();
                              },
                              onEdit: () async {
                                await viewModel.fetchUserPosts();
                              },
                            ),
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

Organization mapMyPostToOrganization(MyPost myPost) {
  return Organization(
    id: myPost.postId,
    imageUrls: myPost.imageUrls ?? [],
    name: myPost.name ?? '',
    tags: myPost.tags ?? [],
    title: myPost.title ?? '',
    description: myPost.description ?? '',
    providers: myPost.providers ?? [],
    about: myPost.about ?? '',
    socialLinks: myPost.socialLinks ?? '',
  );
}
