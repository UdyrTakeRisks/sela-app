import 'package:flutter/material.dart';

import '../../../models/Organizations.dart';
import '../../../size_config.dart';
import '../../../utils/constants.dart';

class OrganizationDescription extends StatelessWidget {
  const OrganizationDescription({
    Key? key,
    required this.organization,
    required this.pressOnSeeMore,
  }) : super(key: key);

  final Organization organization;
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
                organization.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(20),
                right: getProportionateScreenWidth(64),
              ),
              child: Text(
                organization.title,
                style: const TextStyle(
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
                  color: organization.isFavourite
                      ? kPrimaryColor
                      : const Color(0xFFDBDEE4),
                ),
                onPressed: () {
                  // Add your save logic here
                  // change the isFavourite value
                  organization.isFavourite = !organization.isFavourite;
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
