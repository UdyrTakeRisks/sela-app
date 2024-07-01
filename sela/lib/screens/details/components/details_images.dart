import 'package:flutter/material.dart';

import '../../../models/Organizations.dart';
import '../../../size_config.dart';
import '../../../utils/constants.dart';

class OrganizationImages extends StatefulWidget {
  const OrganizationImages({
    Key? key,
    required this.organization,
  }) : super(key: key);

  final Organization organization;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<OrganizationImages> {
  late PageController _pageController;
  int selectedImage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedImage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: getProportionateScreenWidth(138),
          height: getProportionateScreenWidth(138),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.organization.imageUrls!.length,
            onPageChanged: (index) {
              setState(() {
                selectedImage = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Hero(
                    tag: widget.organization.id.toString(),
                    child: Image.network(
                      widget.organization.imageUrls![selectedImage],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Center(child: Icon(Icons.error));
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(widget.organization.imageUrls!.length,
                (index) => buildSmallProductPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallProductPreview(int index) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: defaultDuration,
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: defaultDuration,
        margin: EdgeInsets.only(right: 15),
        padding: EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(
          widget.organization.imageUrls![index],
          errorBuilder: (context, error, stackTrace) {
            return Center(child: Icon(Icons.error));
          },
        ),
      ),
    );
  }
}
