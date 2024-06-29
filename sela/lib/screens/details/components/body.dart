import 'package:flutter/material.dart';
import 'package:sela/screens/details/components/details_description.dart';
import 'package:sela/screens/details/components/reviews.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/default_button.dart';
import '../../../models/Organizations.dart';
import '../../../size_config.dart';
import 'details_images.dart';
import 'top_rounded_container.dart';

class Body extends StatelessWidget {
  final Organization organization;
  final int index;

  const Body({super.key, required this.organization, required this.index});

  void _launchURL() async {
    final Uri url = Uri.parse(organization.socialLinks);
    try {
      if (await launchUrl(url)) {
        throw Exception('Could not launch $url');
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Error launching URL: $e');
      // Handle error as needed, e.g., show a dialog or toast with an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    String providersList = organization.providers.join('\n');

    List<Review> reviews = [
      Review(
        name: 'John Doe',
        review: 'Great organization!',
        rating: 4.5,
      ),
      Review(
          name: 'Omar Smith',
          review: 'Had a wonderful experience.',
          rating: 3.0),
      Review(
          name: 'Mohamed Ali',
          review: 'Had a wonderful experience.',
          rating: 2.5),
      Review(
          name: 'Ahmed Hassan',
          review: 'Had a wonderful experience.',
          rating: 1.0),
      // Add more reviews as needed
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          OrganizationImages(organization: organization),
          Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
            ),
            child: TopRoundedContainer(
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
                child: Column(
                  children: [
                    OrganizationDescription(
                      organization: organization,
                      pressOnSeeMore: () {},
                    ),
                    DefaultTabController(
                      length: 4,
                      child: Column(
                        children: [
                          const TabBar(
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Color(0xFF356899),
                            tabs: [
                              Tab(text: "Description"),
                              Tab(text: "Providers"),
                              Tab(text: "About"),
                              Tab(text: "Reviews"),
                            ],
                          ),
                          SizedBox(
                            height: getProportionateScreenWidth(310),
                            child: TabBarView(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text(organization.description),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text(providersList),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Text(organization.about),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Reviews(
                                      reviews:
                                          reviews), // Use the Reviews widget
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            // margin: EdgeInsets.only(top: getProportionateScreenWidth(20)),
            color: Colors.white,
            // padding: EdgeInsets.only(top: getProportionateScreenWidth(20)),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 50.0,
                right: 50.0,
                bottom: 25.0,
              ),
              child: DefaultButton(
                text: "Go Volunteer",
                press: _launchURL,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
