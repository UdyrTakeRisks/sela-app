import 'package:flutter/material.dart';
import 'package:sela/models/Organizations.dart';
import 'package:sela/size_config.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../utils/colors.dart';

class NewOrganizationCard extends StatefulWidget {
  const NewOrganizationCard({
    super.key,
    required this.organization,
    required this.press,
  });

  final Organization organization;
  final GestureTapCallback press;

  @override
  State<NewOrganizationCard> createState() => _NewOrganizationCardState();
}

class _NewOrganizationCardState extends State<NewOrganizationCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.press,
      child: Container(
        padding: EdgeInsets.all(getProportionateScreenWidth(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
          image: DecorationImage(
            image: const AssetImage("assets/images/Mask.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              primaryColor,
              BlendMode.softLight,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: widget.organization.imageUrls != null &&
                          widget.organization.imageUrls!.isNotEmpty
                      ? Image.network(
                          widget.organization.imageUrls![0] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.people_alt,
                          size: 50,
                          color: primaryColor,
                        )),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.organization.name ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.organization.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.organization.tags != null &&
                      widget.organization.tags!.isNotEmpty)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: widget.organization.tags!
                            .map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                margin: const EdgeInsets.only(right: 6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  tag,
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12,
                                  ),
                                ),
                              );
                            })
                            .take(3) // Take only the first 3 tags
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.ios_share_rounded),
                  color: Colors.white,
                  onPressed: () async {
                    await Share.share(
                      'Check out this organization: ${widget.organization.name}\nTitle: ${widget.organization.title}\nDescription: ${widget.organization.description}\nLink: ${widget.organization.socialLinks}',
                    );
                  },
                ),
                const SizedBox(height: 8),
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Know more',
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
