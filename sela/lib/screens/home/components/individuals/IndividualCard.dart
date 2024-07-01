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
    // Default placeholder URL

    return GestureDetector(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        padding: const EdgeInsets.all(20),
        width: 160,
        decoration: BoxDecoration(
          color: primaryColor,
          image: DecorationImage(
            image: AssetImage("assets/images/Mask.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.screen,
            ),
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.all(5),
              child: ClipOval(
                  child: individual.imageUrls != null &&
                          individual.imageUrls!.isNotEmpty
                      ? Image.network(
                          individual.imageUrls![0],
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.person,
                          size: 80,
                          color: primaryColor,
                        )),
            ),
            const SizedBox(height: 10),
            Text(
              individual.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
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
                backgroundColor: Colors.white,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text('Know More', style: TextStyle(color: primaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}
