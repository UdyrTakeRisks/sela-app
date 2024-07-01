import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sela/screens/home/components/discount_banner.dart';
import 'package:sela/screens/home/components/search_field.dart';

import '../../../size_config.dart';
import '../../../utils/colors.dart';
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

    // await Future.delayed(const Duration(seconds: 1));
    // show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshed'),
      ),
    );
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
        child: SingleChildScrollView(
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
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
    );
  }
}
