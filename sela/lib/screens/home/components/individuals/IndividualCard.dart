// lib/screens/home/components/individuals/individual_card.dart

import 'package:flutter/material.dart';
import 'package:sela/models/individual.dart';

class IndividualCard extends StatelessWidget {
  final Individual individual;
  final VoidCallback press;

  IndividualCard({
    required this.individual,
    required this.press,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFEBF1FF),
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
                individual.imageUrls.isNotEmpty
                    ? individual.imageUrls[0]
                    : AssetImage('assets/images/individual.png') as String,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              individual.name,
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
                backgroundColor: const Color(0xFF5397F0),
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
    );
  }
}
