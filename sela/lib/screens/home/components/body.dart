import 'package:flutter/material.dart';
import 'package:sela/screens/home/components/discount_banner.dart';

import '../../../size_config.dart';
import 'app_bar.dart';
import 'home_header.dart';
import 'organizations.dart';
import 'popular_product.dart';

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const AppBarWelcome(),
            SizedBox(height: getProportionateScreenHeight(30)),
            const HomeHeader(),
            SizedBox(height: getProportionateScreenWidth(10)),
            // const SpecialOffers(),
            const DiscountBanner(),
            // const Categories(),
            const Organizations(),
            SizedBox(height: getProportionateScreenWidth(30)),
            PopularProducts(),
            SizedBox(height: getProportionateScreenWidth(30)),
          ],
        ),
      ),
    );
  }
}
