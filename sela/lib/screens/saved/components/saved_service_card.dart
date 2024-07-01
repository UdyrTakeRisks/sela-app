import 'package:flutter/material.dart';

import '../../../models/Organizations.dart';
import '../../../models/save_post.dart';
import '../../details/details_screen.dart';

class SavedServiceCard extends StatelessWidget {
  final SavedPost post;

  SavedServiceCard({required this.post});

  @override
  Widget build(BuildContext context) {
    // Map SavedPost to Organization if possible
    Organization organization = Organization(
      id: post.postId,
      name: post.name,
      title: post.title,
      description: post.description,
      imageUrls: post.imageUrls,
      type: post.type == 'Organization' ? 0 : 1, tags: post.tags,
      providers: post.providers, about: post.about,
      socialLinks: post.socialLinks, // Adjust as per your model
    );

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          DetailsScreen.routeName,
          arguments:
              DetailsArguments(index: post.postId, organization: organization),
        );
      },
      child: Card(
        color: Color(0xFFEBF1FF),
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: [
              Image.network(
                post.imageUrls.isNotEmpty ? post.imageUrls[0] : '',
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(post.title),
                    Text(post.description),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
