// lib/screens/home/components/individuals/individuals.dart

import 'package:flutter/material.dart';
import 'package:sela/models/individual.dart';

import '../../../../size_config.dart';
import '../section_title.dart';
import 'IndividualCard.dart';
import 'individual_service.dart';

class Individuals extends StatefulWidget {
  const Individuals({Key? key}) : super(key: key);

  @override
  _IndividualsState createState() => _IndividualsState();
}

class _IndividualsState extends State<Individuals> {
  late Future<List<Individual>> futureIndividuals;

  @override
  void initState() {
    super.initState();
    futureIndividuals = IndividualService().fetchIndividuals();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SectionTitle(
            title: 'Individuals',
            press: () {},
          ),
        ),
        const SizedBox(height: 20),
        FutureBuilder<List<Individual>>(
          future: futureIndividuals,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Text("ERROR: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No Individuals Found");
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...snapshot.data!.map((individual) => IndividualCard(
                          individual: individual,
                          press: () {},
                        )),
                    SizedBox(width: getProportionateScreenWidth(20)),
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
