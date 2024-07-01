import 'package:flutter/material.dart';
import 'package:sela/models/individual.dart';
import 'package:sela/size_config.dart';

import '../../../../utils/colors.dart';

class NewIndividualCard extends StatefulWidget {
  const NewIndividualCard({
    super.key,
    required this.individual,
    required this.press,
  });

  final Individual individual;
  final GestureTapCallback press;

  @override
  State<NewIndividualCard> createState() => _NewIndividualCardState();
}

class _NewIndividualCardState extends State<NewIndividualCard> {
  bool isSaved = false;

  void _saved() {
    setState(() {
      isSaved = !isSaved;
    });
  }

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
                  child: widget.individual.imageUrls != null &&
                          widget.individual.imageUrls!.isNotEmpty
                      ? Image.network(
                          widget.individual.imageUrls![0] ?? '',
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
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
                    widget.individual.name ?? '',
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
                    widget.individual.title ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white60,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (widget.individual.tags != null &&
                      widget.individual.tags!.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: -6,
                      children: widget.individual.tags!
                          .take(3) // Take only the first 3 tags
                          .toList()
                          .map((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          margin: const EdgeInsets.only(top: 6),
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
                      }).toList(),
                    ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: _saved,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "6d",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
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
