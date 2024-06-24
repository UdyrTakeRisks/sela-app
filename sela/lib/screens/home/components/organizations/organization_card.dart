import 'package:flutter/material.dart';

import '../../../../size_config.dart';

class OrganizationCard extends StatelessWidget {
  const OrganizationCard({
    super.key,
    required this.logo,
    required this.name,
    required this.title,
    required this.tags,
    required this.press,
    required this.index,
  });

  final int index;
  final String logo, name, title;
  final List<String> tags;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 10),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: getProportionateScreenWidth(242),
          height: getProportionateScreenWidth(120),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/Mask.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.screen,
              ),
            ),
            color: const Color(0xFF356899),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      logo,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
