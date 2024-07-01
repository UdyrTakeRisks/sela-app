import 'package:flutter/material.dart';

import 'review_input_dialog.dart';

class ReviewInput extends StatelessWidget {
  final Function(String review, double rating) onSubmit;

  const ReviewInput({super.key, required this.onSubmit});

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReviewInputDialog(onSubmit: onSubmit);
      },
    );
    print('Review dialog opened');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showReviewDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: const Row(
          children: [
            Expanded(
              child: Text('Tap to add a review...'),
            ),
            Icon(Icons.edit),
          ],
        ),
      ),
    );
  }
}
