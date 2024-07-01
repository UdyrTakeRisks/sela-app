import 'package:flutter/material.dart';
import 'package:sela/models/Organizations.dart'; // Import your Organization model
import 'package:sela/models/individual.dart';

import '../../../../size_config.dart';
import '../../../details/details_screen.dart'; // Import DetailsScreen if not already imported
import '../section_title.dart';
import 'IndividualCard.dart';
import 'all_individuals.dart';
import 'individual_service.dart';

class Individuals extends StatefulWidget {
  const Individuals({super.key});

  @override
  IndividualsState createState() => IndividualsState();
}

class IndividualsState extends State<Individuals> {
  late Future<List<Individual>> futureIndividuals;

  @override
  void initState() {
    super.initState();
    futureIndividuals = IndividualService().fetchIndividuals();
  }

  Future<void> handleRefresh() async {
    setState(() {
      futureIndividuals =
          IndividualService().fetchIndividuals(); // Refresh the list
    });
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
            press: () =>
                Navigator.pushNamed(context, AllIndividualsScreen.routeName),
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
                    ...snapshot.data!.map((individual) => buildIndividualCard(
                        individual, snapshot.data!.indexOf(individual))),
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

  Widget buildIndividualCard(Individual individual, int index) {
    // Map Individual to Organization
    Organization organization = Organization(
      id: individual.postId, // Adjust according to your Individual model
      name: individual.name,
      title: individual.title,
      description: individual.description,
      imageUrls: individual.imageUrls,
      type: individual.type == 'Organization'
          ? 0
          : 1, // Adjust based on your conditions
      tags: individual.tags,
      providers: individual.providers,
      about: individual.about,
      socialLinks: individual.socialLinks,
    );

    return IndividualCard(
      individual: individual,
      press: () {
        Navigator.pushNamed(
          context,
          DetailsScreen.routeName,
          arguments: DetailsArguments(
            organization: organization,
            index: index,
          ),
        );
      },
    );
  }
}
