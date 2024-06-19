import 'package:flutter/material.dart';
import 'package:sela/models/Organizations.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final DetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as DetailsArguments;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F9),
      appBar: CustomAppBar(
        rating: args.organization.rating,
      ),
      body: Body(product: args.organization, index: args.index),
    );
  }
}

class DetailsArguments {
  final Organization organization;
  final int index;

  DetailsArguments({required this.organization, required this.index});
}
