import 'package:flutter/material.dart';
import 'package:sela/models/Organizations.dart';

import 'components/body.dart';
import 'components/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  static String routeName = "/details";

  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments args =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments;

    return Scaffold(
      backgroundColor: Color(0xFFF5F6F9),
      appBar: CustomAppBar(
        rating: args.product.rating,
      ),
      body: Body(product: args.product, index: args.index),
    );
  }
}

class ProductDetailsArguments {
  final Product product;
  final int index;

  ProductDetailsArguments({required this.product, required this.index});
}
