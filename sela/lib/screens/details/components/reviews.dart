import 'package:flutter/material.dart';

import '../../../models/review.dart';
import '../../../utils/colors.dart';
import 'review_input.dart';

class Reviews extends StatefulWidget {
  final List<Review> reviews;

  const Reviews({Key? key, required this.reviews}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _reviews.addAll(widget.reviews);
  }

  void _addReview(String name, String review, double rating) {
    setState(() {
      _reviews.add(Review(username: name, description: review, rating: rating));
    });
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating
              ? Icons.star
              : index < rating + 0.5
                  ? Icons.star_half_outlined
                  : Icons.star_border,
          color: primaryColor,
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _reviews.isEmpty
              ? const Center(child: Text('No reviews found'))
              : ListView.builder(
                  itemCount: _reviews.length,
                  itemBuilder: (context, index) {
                    final review = _reviews[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: backgroundColor1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: backgroundColor2,
                                  child: Text(
                                    review.username[0],
                                    style: TextStyle(color: primaryColor),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  review.username,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: textColor1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              review.description,
                              style: TextStyle(color: textColor2),
                            ),
                            const SizedBox(height: 8),
                            _buildStarRating(review.rating),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: ReviewInput(onSubmit: _addReview),
        ),
      ],
    );
  }
}
