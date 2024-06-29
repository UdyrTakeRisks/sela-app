import 'package:flutter/material.dart';
import 'package:sela/utils/colors.dart';

import '../../../models/my_post_model.dart';
import '../../../size_config.dart';

class PostCard extends StatelessWidget {
  final MyPost post;

  const PostCard({Key? key, required this.post}) : super(key: key);

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
                    child: Center(
                      child: Text(
                        'No image',
                      ),
                    ),
                  ),
            SizedBox(height: getProportionateScreenHeight(20)),
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
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
