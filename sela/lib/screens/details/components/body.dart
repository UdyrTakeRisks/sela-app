import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sela/screens/details/components/details_description.dart';
import 'package:sela/screens/details/components/reviews.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/default_button.dart';
import '../../../models/Organizations.dart';
import '../../../models/review.dart';
import '../../../size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/env.dart';
import 'details_images.dart';
import 'top_rounded_container.dart';

class Body extends StatefulWidget {
  final Organization organization;
  final int index;

  const Body({super.key, required this.organization, required this.index});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<List<Review>> futureReviews;

  @override
  void initState() {
    super.initState();
    futureReviews = fetchReviews(widget.organization.id);
  }

  Future<List<Review>> fetchReviews(int postId) async {
    final response = await http.get(
      Uri.parse('$DOTNET_URL_API_BACKEND/Post/view/reviews/$postId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => Review.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      // No post reviews found for this post.
      return [];
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  void _launchURL() async {
    final Uri url = Uri.parse(widget.organization.socialLinks);
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

  Future<void> refreshReviews() async {
    setState(() {
      futureReviews = fetchReviews(widget.organization.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    String providersList = widget.organization.providers!.join('\n');

    return SingleChildScrollView(
      child: Column(
        children: [
          OrganizationImages(organization: widget.organization),
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
                      organization: widget.organization,
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
                            height: MediaQuery.of(context).size.height - 580,
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child:
                                        Text(widget.organization.description),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text(providersList),
                                  ),
                                ),
                                SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text(widget.organization.about),
                                  ),
                                ),
                                RefreshIndicator(
                                  color: primaryColor,
                                  semanticsLabel: "Refresh Organizations",
                                  semanticsValue: "Refresh Organizations",
                                  onRefresh: () async {
                                    setState(() {
                                      futureReviews =
                                          fetchReviews(widget.organization.id);
                                    });
                                    // show a snackbar
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Reviews refreshed'),
                                      ),
                                    );
                                  },
                                  child: FutureBuilder<List<Review>>(
                                    future: futureReviews,
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else if (snapshot.hasError) {
                                        return Center(
                                            child: Text(
                                                'Error: ${snapshot.error}'));
                                      } else if (!snapshot.hasData ||
                                          snapshot.data!.isEmpty) {
                                        return Center(
                                          child: Reviews(
                                            reviews: const [],
                                            postId: widget.organization.id,
                                            refreshReviews: refreshReviews,
                                          ),
                                        );
                                      } else {
                                        return Reviews(
                                          reviews: snapshot.data!,
                                          postId: widget.organization.id,
                                          refreshReviews: refreshReviews,
                                        );
                                      }
                                    },
                                  ),
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
            color: Colors.white,
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
