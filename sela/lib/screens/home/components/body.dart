import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kommunicate_flutter/kommunicate_flutter.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sela/screens/home/components/discount_banner.dart';
import 'package:sela/screens/home/components/search_field.dart';

import '../../../size_config.dart';
import '../../../utils/colors.dart';
import '../../../utils/env.dart';
import 'app_bar.dart';
import 'individuals/individuals.dart';
import 'organizations/organizations.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<OrganizationsState> _organizationsKey = GlobalKey();
  final GlobalKey<AppBarWelcomeState> _appBarWelcomeKey = GlobalKey();
  final GlobalKey<IndividualsState> _individualsKey = GlobalKey();

  Future<void> _handleRefresh() async {
    await _organizationsKey.currentState?.fetchOrganizations();
    await _appBarWelcomeKey.currentState?.fetchData();
    await _individualsKey.currentState?.handleRefresh(); // Refresh Individuals
    Fluttertoast.showToast(
      msg: "Refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: primaryColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _launchChat() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            color: primaryColor,
          ),
        );
      },
    );

    try {
      dynamic conversationObject = {
        'appId': KOMMUNICATE_APP_ID, // Replace with your Kommunicate App ID
      };
      await KommunicateFlutterPlugin.buildConversation(conversationObject);
    } catch (e) {
      print("Failed to launch conversation: $e");
    } finally {
      Navigator.of(context).pop(); // Close the loading dialog

      // Show chat popup
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return FutureBuilder(
            future: KommunicateFlutterPlugin.buildConversation({
              'appId':
                  KOMMUNICATE_APP_ID, // Replace with your Kommunicate App ID
            }),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text(
                      'Failed to load chat: ${snapshot.error}'), // Display error message
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                );
              } else if (snapshot.hasData) {
                Navigator.of(context).pop();
                // Ensure snapshot has valid data before using it
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: snapshot.data
                        as Widget, // Ensure snapshot data is treated as Widget
                  ),
                );
              } else {
                return const SizedBox.shrink(); // Handle other cases gracefully
              }
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: primaryColor,
      height: 200,
      backgroundColor: backgroundColor1,
      animSpeedFactor: 2.0,
      showChildOpacityTransition: false,
      child: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  AppBarWelcome(key: _appBarWelcomeKey),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  GestureDetector(
                    onTap: () =>
                        Navigator.pushNamed(context, SearchScreen.routeName),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 4),
                            blurRadius: 30,
                            color: primaryColor.withOpacity(0.23),
                          ),
                        ],
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(width: 10),
                          Text('Search'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  DiscountBanner(),
                  Organizations(key: _organizationsKey),
                  SizedBox(height: getProportionateScreenWidth(10)),
                  const Individuals(),
                ],
              ),
            ),
            Positioned(
              bottom: 25,
              right: 25,
              child: FloatingActionButton(
                onPressed: _launchChat,
                backgroundColor: primaryColor,
                child: const Icon(Icons.chat, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
