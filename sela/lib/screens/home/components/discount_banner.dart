import 'package:flutter/material.dart';
import 'package:flutter_swipe/flutter_swipe.dart';

import '../../../size_config.dart';

class DiscountBanner extends StatelessWidget {
  DiscountBanner({Key? key}) : super(key: key);

  final List<String> advertisements = [
    'assets/images/ad1.png',
    'assets/images/ad2.png',
    'assets/images/ad3.png',
    'assets/images/ad4.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // margin: EdgeInsets.all(getProportionateScreenWidth(20)),
      padding: EdgeInsets.symmetric(
        horizontal: getProportionateScreenWidth(20),
        vertical: getProportionateScreenWidth(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(120),
            child: Swiper(
              itemCount: advertisements.length,
              autoplay: true,
              pagination: const SwiperPagination(
                builder: DotSwiperPaginationBuilder(
                  color: Colors.grey,
                  activeColor: Colors.white,
                  activeSize: 8.0,
                  size: 6.0,
                ),
              ),
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        advertisements[index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
