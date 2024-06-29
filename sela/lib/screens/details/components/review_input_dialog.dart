import 'package:flutter/material.dart';

class ReviewInputDialog extends StatefulWidget {
  final Function(String review, double rating) onSubmit;

  const ReviewInputDialog({super.key, required this.onSubmit});

  @override
  _ReviewInputDialogState createState() => _ReviewInputDialogState();
}

class _ReviewInputDialogState extends State<ReviewInputDialog> {
  final _reviewController = TextEditingController();
  double _rating = 0.0;

  void _submitReview() {
    if (_reviewController.text.isNotEmpty && _rating > 0) {
      widget.onSubmit(_reviewController.text, _rating);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and give a rating'),
        ),
      );
    }
    print('Review submitted');
    print('Review: ${_reviewController.text}');
    print('Rating: $_rating');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(labelText: 'Review'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Rating:'),
                  Expanded(
                    child: Slider(
                      value: _rating,
                      min: 0,
                      max: 5,
                      divisions: 10,
                      label: _rating.toString(),
                      onChanged: (value) {
                        setState(() {
                          _rating = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _submitReview,
                child: const Text('Submit Review'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
