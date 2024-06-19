import 'package:flutter/material.dart';
import 'package:sela/screens/details/components/details_description.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../components/default_button.dart';
import '../../../models/Organizations.dart';
import '../../../size_config.dart';
import 'details_images.dart';
import 'top_rounded_container.dart';

class Body extends StatelessWidget {
  final Organization product;
  final int index;

  const Body({super.key, required this.product, required this.index});

  void _launchURL() async {
    final Uri url = Uri.parse('https://yanfaa.com/eg/home');
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          ProductImages(product: product),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  product: product,
                  pressOnSeeMore: () {},
                ),
                DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      const TabBar(
                        labelColor: Colors.black,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: Color(0xFF356899),
                        tabs: [
                          Tab(text: "Description"),
                          Tab(text: "About"),
                          Tab(text: "Reviews"),
                        ],
                      ),
                      SizedBox(
                        height: getProportionateScreenWidth(200),
                        child: TabBarView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(product.description),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("About title goes here."),
                            ),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text("Reviews go here."),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    // ColorDots(product: product),
                    TopRoundedContainer(
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: SizeConfig.screenWidth * 0.15,
                          right: SizeConfig.screenWidth * 0.15,
                          bottom: getProportionateScreenWidth(40),
                          top: getProportionateScreenWidth(15),
                        ),
                        child: DefaultButton(
                          text: "Go",
                          press: _launchURL,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
