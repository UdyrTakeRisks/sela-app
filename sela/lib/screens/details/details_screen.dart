import 'package:flutter/material.dart';
import 'package:sela/models/Organizations.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';
import 'components/rating_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  static String routeName = "/details";

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late Future<double> ratingFuture;
  late DetailsArguments args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as DetailsArguments;
    ratingFuture = RatingService().fetchRating(args.organization.id);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: ratingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Color(0xFFF5F6F9),
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            backgroundColor: Color(0xFFF5F6F9),
            body: Center(child: Text('Failed to load rating')),
          );
        } else {
          final rating = snapshot.data ?? 0.0;
          return Scaffold(
            backgroundColor: Color(0xFFF5F6F9),
            appBar: CustomAppBar(
              rating: rating,
            ),
            body: Body(organization: args.organization, index: args.index),
          );
        }
      },
    );
  }
}

class DetailsArguments {
  final Organization organization;
  final int index;

  DetailsArguments({required this.organization, required this.index});
}
