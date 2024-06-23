import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sela/screens/home/components/discount_banner.dart';

import '../../../size_config.dart';
import '../../../utils/colors.dart';
import 'app_bar.dart';
import 'home_header.dart';
import 'individuals.dart';
import 'organizations.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final GlobalKey<OrganizationsState> _organizationsKey = GlobalKey();

  Future<void> _handleRefresh() async {
    await _organizationsKey.currentState?.fetchOrganizations();
    await Future.delayed(const Duration(seconds: 1));
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
              const AppBarWelcome(),
              SizedBox(height: getProportionateScreenHeight(30)),
              const HomeHeader(),
              SizedBox(height: getProportionateScreenWidth(10)),
              const DiscountBanner(),
              Organizations(key: _organizationsKey),
              SizedBox(height: getProportionateScreenWidth(30)),
              Individuals(),
              SizedBox(height: getProportionateScreenWidth(30)),
            ],
          ),
        ),
      ),
    );
  }
}
