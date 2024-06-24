import 'package:flutter/material.dart';

import '../../../models/my_post_model.dart';
import '../../../size_config.dart';

class PostCard extends StatelessWidget {
  final MyPost post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrls != null && post.imageUrls!.isNotEmpty)
              Image.network(post.imageUrls![0]),
            SizedBox(height: getProportionateScreenHeight(30)),
            Text(
              post.title ?? '', // Use default value if title is null
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              post.description ??
                  '', // Use default value if description is null
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: (post.tags ?? [])
                  .map((tag) => Chip(label: Text(tag)))
                  .toList(), // Use empty list if tags is null
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "Posted by: ${post.name ?? ''}"), // Use default value if name is null
              ],
            ),
          ],
        ),
      ),
    );
  }
}
