import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/review.dart';
import '../../../utils/colors.dart';
import '../../../utils/env.dart';
import 'review_input.dart';

class Reviews extends StatefulWidget {
  final List<Review> reviews;
  final int postId;
  final VoidCallback refreshReviews;

  const Reviews(
      {super.key,
      required this.reviews,
      required this.postId,
      required this.refreshReviews});

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

  Future<void> _addReview(String reviewText, double rating) async {
    print('Adding review: $reviewText, $rating');
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString('cookie');

      print('Cookies: $cookies');
      var url =
          Uri.parse('$DOTNET_URL_API_BACKEND/Post/review/${widget.postId}');

      print('URL: $url');

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': cookies!,
      };

      var body = jsonEncode({
        'description': reviewText,
        'rating': rating,
      });

      print('Adding review: $body');

      var response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        // Refresh the reviews in the parent widget
        widget.refreshReviews();

        print('Review added successfully');
        print('Response: ${response.body}');
        // Show a snackbar with a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review added successfully'),
          ),
        );
      } else {
        // Handle errors or show feedback based on response
        print('Failed to add review: ${response.statusCode}');
        // You can show an error message or handle the response accordingly
        // e.g., show a dialog or toast with an error message

        // Show a snackbar with an error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add review. Please try again later.'),
          ),
        );
      }
    } catch (e) {
      print('Error adding review: $e');
      // Handle any other errors
    }
  }

  Future<void> _deleteReview() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var cookies = prefs.getString('cookie');

      var url =
          Uri.parse('$DOTNET_URL_API_BACKEND/Post/un-review/${widget.postId}');

      var headers = {
        'Content-Type': 'application/json',
        'Cookie': cookies!,
      };

      var response = await http.delete(url, headers: headers);

      if (response.statusCode == 200) {
        // Refresh the reviews in the parent widget
        widget.refreshReviews();

        // Show a snackbar with a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review deleted successfully'),
          ),
        );
      } else {
        // Handle errors or show feedback based on response
        print('Failed to delete review: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete review. Please try again later.'),
          ),
        );
      }
    } catch (e) {
      print('Error deleting review: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error occurred while deleting review.'),
        ),
      );
    }
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _deleteReview();
                                  },
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
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: ReviewInput(onSubmit: _addReview),
        ),
      ],
    );
  }
}
