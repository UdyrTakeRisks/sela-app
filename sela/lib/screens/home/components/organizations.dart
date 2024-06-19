import 'package:flutter/material.dart';
import 'package:sela/models/Product.dart';

import '../../../size_config.dart';
import '../../details/details_screen.dart';
import 'section_title.dart';

class Organizations extends StatelessWidget {
  const Organizations({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: "Organizations",
            press: () {},
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              OrganizationCard(
                logo:
                    "assets/images/yanfaa.png", // Adjust the path as necessary
                name: "Yanfaa",
                category: "Learning",
                tags: const ["Designing", "Marketing", "English"],
                rating: 4,
                serviceType: "Online Service",
                press: () => Navigator.pushNamed(context, '/details',
                    arguments:
                        ProductDetailsArguments(product: demoProducts[1])),
              ),
              OrganizationCard(
                logo: "assets/images/vso.png", // Adjust the path as necessary
                name: "Vos Organization",
                category: "Education",
                tags: const ["Science", "Math", "History"],
                rating: 5,
                serviceType: "In-Person",
                press: () => Navigator.pushNamed(context, '/details'),
              ),
              SizedBox(width: getProportionateScreenWidth(20)),
            ],
          ),
        ),
      ],
    );
  }
}

class OrganizationCard extends StatelessWidget {
  const OrganizationCard({
    super.key,
    required this.logo,
    required this.name,
    required this.category,
    required this.tags,
    required this.rating,
    required this.serviceType,
    required this.press,
  });

  final String logo, name, category, serviceType;
  final List<String> tags;
  final int rating;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: getProportionateScreenWidth(242),
          height: getProportionateScreenWidth(110),
          padding: const EdgeInsets.all(16),
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
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    logo,
                    width: 40,
                    height: 40,
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
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.bookmark,
                    color: Colors.white60,
                    size: 24,
                  ),
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
                          color: Colors.black
                              .withOpacity(0.1), // Light transparent color
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
              // const SizedBox(height: 10),
              // Row(
              //   children: [
              //     Row(
              //       children: List.generate(
              //         rating,
              //         (index) => const Icon(
              //           Icons.star,
              //           color: Colors.amber,
              //           size: 16,
              //         ),
              //       ),
              //     ),
              //     const Spacer(),
              //     // Text(
              //     //   serviceType,
              //     //   style: const TextStyle(
              //     //     color: Colors.white70,
              //     //     fontSize: 12,
              //     //   ),
              //     // ),
              //   ],
              // ),
              // const SizedBox(height: 10),
              // TextButton(
              //   onPressed: press,
              //   style: TextButton.styleFrom(
              //     backgroundColor: Colors.white24,
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(8),
              //     ),
              //   ),
              //   child: const Text(
              //     "Learn More",
              //     style: TextStyle(
              //       color: Colors.white,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
