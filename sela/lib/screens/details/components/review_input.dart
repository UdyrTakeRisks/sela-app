import 'package:flutter/material.dart';

import 'review_input_dialog.dart';

class ReviewInput extends StatelessWidget {
  final Function(String name, String review, double rating) onSubmit;

  const ReviewInput({Key? key, required this.onSubmit}) : super(key: key);

  void _showReviewDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReviewInputDialog(onSubmit: onSubmit);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showReviewDialog(context);
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
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
