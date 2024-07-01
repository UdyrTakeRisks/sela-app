import 'package:flutter/material.dart';
import 'package:sela/models/individual.dart';
import 'package:sela/utils/colors.dart';

class IndividualCard extends StatelessWidget {
  final Individual individual;
  final VoidCallback press;

  const IndividualCard({
    super.key,
    required this.individual,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    String imageUrl = individual.imageUrls!.isNotEmpty
        ? individual.imageUrls![0]
        : 'assets/images/individual.jpg'; // Default placeholder URL

    return GestureDetector(
      onTap: press,
      child: SizedBox(
        width: 180,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: backgroundColor4,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              ClipOval(
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/org.jpg', // Placeholder image asset path
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text(
                individual.name,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                individual.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: press,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Know More',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
