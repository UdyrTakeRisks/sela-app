import 'package:flutter/material.dart';

import '../../../models/Organizations.dart';
import '../../../size_config.dart';
import '../../../utils/constants.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    required this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenWidth(20)),
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(20),
                right: getProportionateScreenWidth(64),
              ),
              child: Text(
                product.title,
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.ios_share_rounded),
                color: Colors.grey,
                onPressed: () {
                  // Add your share logic here
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.bookmark,
                  color: product.isFavourite
                      ? kPrimaryColor
                      : const Color(0xFFDBDEE4),
                ),
                onPressed: () {
                  // Add your save logic here
                  // change the isFavourite value
                  product.isFavourite = !product.isFavourite;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
