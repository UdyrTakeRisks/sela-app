import 'package:flutter/material.dart';
import 'package:sela/screens/home/components/section_title.dart';

import '../../../../models/Individual.dart';
import 'IndividualCard.dart';

class Individuals extends StatelessWidget {
  final List<Individual> individuals = [
    Individual(
      name: 'Ahmed Ali',
      service: 'Learning',
      imageUrl:
          'https://ihaofykdrzgouxpitrvi.supabase.co/storage/v1/object/public/postimages/yanfaa/images/yanfaa_4.png?t=2024-06-19T15%3A23%3A07.781Z',
    ),
    Individual(
      name: 'Mohamed Alaa',
      service: 'Volunteering',
      imageUrl:
          'https://www.wilsoncenter.org/sites/default/files/media/images/person/james-person-1.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: 'Individuals',
            press: () {},
          ),
        ),
        const SizedBox(height: 20),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: individuals.map((individual) {
              return IndividualCard(
                individual: individual,
                press: () {
                  // Navigate to detail page
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
