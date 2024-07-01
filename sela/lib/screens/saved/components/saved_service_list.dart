import 'package:flutter/cupertino.dart';
import 'package:sela/screens/saved/components/saved_service_card.dart';

import '../../../models/save_post.dart';

class SavedServiceList extends StatelessWidget {
  final String filter;
  final List<SavedPost> savedPosts;

  SavedServiceList({required this.savedPosts, required this.filter});

  @override
  Widget build(BuildContext context) {
    List<SavedPost> filteredServices = savedPosts.where((post) {
      if (filter == 'All') return true;
      return post.type.toLowerCase() == filter.toLowerCase();
    }).toList();

    return ListView.builder(
      itemCount: filteredServices.length,
      itemBuilder: (context, index) {
        return SavedServiceCard(post: filteredServices[index]);
      },
    );
  }
}
