import 'package:flutter/material.dart';

class ReviewInputDialog extends StatefulWidget {
  final Function(String name, String review, double rating) onSubmit;

  const ReviewInputDialog({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _ReviewInputDialogState createState() => _ReviewInputDialogState();
}

class _ReviewInputDialogState extends State<ReviewInputDialog> {
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();
  double _rating = 0.0;

  void _submitReview() {
    if (_nameController.text.isNotEmpty &&
        _reviewController.text.isNotEmpty &&
        _rating > 0) {
      widget.onSubmit(_nameController.text, _reviewController.text, _rating);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields and give a rating'),
        ),
      );
    }
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
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _reviewController,
                decoration: InputDecoration(labelText: 'Review'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text('Rating:'),
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
                child: Text('Submit Review'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
