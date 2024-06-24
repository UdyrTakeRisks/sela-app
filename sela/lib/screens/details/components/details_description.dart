import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../models/Organizations.dart';
import '../../../size_config.dart';
import '../../../utils/constants.dart';

class OrganizationDescription extends StatefulWidget {
  const OrganizationDescription({
    Key? key,
    required this.organization,
    required this.pressOnSeeMore,
  }) : super(key: key);

  final Organization organization;
  final GestureTapCallback pressOnSeeMore;

  @override
  State<OrganizationDescription> createState() =>
      _OrganizationDescriptionState();
}

class _OrganizationDescriptionState extends State<OrganizationDescription> {
  bool isSaved = false;

  void _saved() {
    setState(() {
      isSaved = !isSaved;
    });
  }

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
                widget.organization.name,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(20),
                right: getProportionateScreenWidth(64),
              ),
              child: Text(
                widget.organization.title,
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
                onPressed: () async {
                  // Add your share logic here
                  // e.g., share(organization);
                  // make him share the organization details and the text i send to him
                  await Share.share(
                      'Check out this organization: ${widget.organization.name}');
                },
              ),
              IconButton(
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
                color: Colors.grey,
                onPressed: _saved,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
