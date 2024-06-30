import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sela/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/my_post_model.dart';
import '../../../size_config.dart';
import '../../../utils/env.dart';
import '../edit_post_page.dart';

class PostCard extends StatelessWidget {
  final MyPost post;
  final Function onDelete;
  final Function onEdit;

  const PostCard(
      {super.key,
      required this.post,
      required this.onDelete,
      required this.onEdit});

  Future<void> _deletePost(BuildContext context, int postId) async {
    final url = Uri.parse('$DOTNET_URL_API_BACKEND/Post/delete/$postId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('cookie');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        if (cookie != null) 'Cookie': cookie,
      },
    );

    if (response.statusCode == 200) {
      // Call the onDelete callback to update the state
      onDelete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post deleted successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete post')),
      );
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePost(context, post.postId);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor4,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            post.imageUrls != null && post.imageUrls!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      post.imageUrls![0],
                      height: getProportionateScreenHeight(200),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    height: getProportionateScreenHeight(200),
                    color: Colors.grey.withOpacity(0.2),
                    child: const Center(
                      child: Text(
                        'No image',
                      ),
                    ),
                  ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title ?? '', // Use default value if title is null
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: getProportionateScreenHeight(8)),
                    Text(
                      post.description ??
                          '', // Use default value if description is null
                    ),
                    SizedBox(height: getProportionateScreenHeight(8)),
                    Wrap(
                      spacing: 8.0,
                      children: (post.tags ?? []).map((tag) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tag,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EditPostPage(post: post),
                          ),
                        );
                        if (result == true) {
                          onEdit();
                        }
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () => _showDeleteConfirmationDialog(context),
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
