import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/save_post.dart';
import '../../utils/colors.dart';
import '../../utils/env.dart';
import 'components/saved_service_list.dart';
import 'saved_post_service.dart';

class SavedScreen extends StatefulWidget {
  static String routeName = "/saved";

  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String photoUrl = '';
  late List<SavedPost> savedPosts = [];
  final SavedPostService _savedPostService = SavedPostService();

  @override
  void initState() {
    super.initState();
    fetchPhoto();
    _tabController = TabController(length: 3, vsync: this);
    fetchSavedPosts();
  }

  Future<void> fetchPhoto() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? cookie = prefs.getString('cookie');

      final url = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/photo');
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      });

      if (response.statusCode == 200) {
        setState(() {
          photoUrl = response.body
              .trim(); // Trim to remove any leading/trailing whitespace
        });
      } else {
        throw Exception('Failed to load photo');
      }
    } catch (e) {
      print('Error fetching photo: $e');
    }
  }

  Future<void> fetchSavedPosts() async {
    try {
      List<SavedPost> fetchedPosts = await _savedPostService.fetchSavedPosts();
      setState(() {
        savedPosts = fetchedPosts;
      });
    } catch (e) {
      print('Error fetching saved posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Services'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          CircleAvatar(
            backgroundColor: backgroundColor4,
            // if there is no image, display the user's first letter
            backgroundImage: photoUrl.isNotEmpty
                ? NetworkImage(photoUrl)
                : const AssetImage('assets/images/profile.png')
                    as ImageProvider, // Use a real URL or asset
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'You saved ${savedPosts.length} Services 👍',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Organizations'),
              Tab(text: 'Individuals'),
            ],
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                SavedServiceList(savedPosts: savedPosts, filter: 'All'),
                SavedServiceList(
                    savedPosts: savedPosts, filter: 'Organization'),
                SavedServiceList(savedPosts: savedPosts, filter: 'Individuals'),
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar:
      //     const CustomBottomNavBar(selectedMenu: MenuState.bookmark),
    );
  }
}
