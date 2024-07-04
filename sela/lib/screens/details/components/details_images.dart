import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

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

  void _showFullScreenImage(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => _FullScreenImageDialog(
          imageUrl: widget.organization.imageUrls![index],
        ),
      ),
    );
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
              return GestureDetector(
                onTap: () {
                  _showFullScreenImage(context, index);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Hero(
                      tag: widget.organization.id.toString() + index.toString(),
                      child: Image.network(
                        widget.organization.imageUrls![index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.error));
                        },
                      ),
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
                (index) => buildSmallPostPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector buildSmallPostPreview(int index) {
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
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        height: getProportionateScreenWidth(48),
        width: getProportionateScreenWidth(48),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: kPrimaryColor.withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: widget.organization.imageUrls != null &&
                widget.organization.imageUrls!.isNotEmpty
            ? Image.network(
                widget.organization.imageUrls![index],
                errorBuilder: (context, error, stackTrace) {
                  return const Center(child: Icon(Icons.error));
                },
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/images/org.jpg', // Use your default image asset path here
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}

class _FullScreenImageDialog extends StatelessWidget {
  final String imageUrl;

  const _FullScreenImageDialog({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Center(
          child: Hero(
            tag: 'fullScreenImage',
            child: PhotoView(
              imageProvider: NetworkImage(imageUrl),
              initialScale: PhotoViewComputedScale.contained,
              minScale: PhotoViewComputedScale.contained * 0.5,
              maxScale: PhotoViewComputedScale.covered * 2.0,
              loadingBuilder: (context, event) =>
                  const Center(child: CircularProgressIndicator()),
              errorBuilder: (context, error, stackTrace) =>
                  const Center(child: Icon(Icons.error)),
            ),
          ),
        ),
      ),
    );
  }
}
