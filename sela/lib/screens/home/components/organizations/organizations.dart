import 'package:flutter/material.dart';
import 'package:sela/models/Organizations.dart';

import '../../../../size_config.dart';
import '../../../details/details_screen.dart';
import '../section_title.dart';
import 'organization_card.dart';
import 'organization_service.dart';

class Organizations extends StatefulWidget {
  const Organizations({
    super.key,
  });

  @override
  OrganizationsState createState() => OrganizationsState();
}

class OrganizationsState extends State<Organizations> {
  late Future<List<Organization>> futureOrganizations;

  @override
  void initState() {
    super.initState();
    futureOrganizations = OrganizationService().fetchOrganizations();
  }

  Future<void> fetchOrganizations() async {
    setState(() {
      futureOrganizations = OrganizationService().fetchOrganizations();
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
            title: "Organizations",
            press: () => Navigator.pushNamed(context, '/all_organizations'),
          ),
        ),
        SizedBox(height: getProportionateScreenWidth(20)),
        FutureBuilder<List<Organization>>(
          future: futureOrganizations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("ERROR: Check your connection and try again"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No Organizations Found");
            } else {
              return SizedBox(
                height: getProportionateScreenWidth(
                    145), // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final org = snapshot.data![index];
                    return OrganizationCard(
                      index: org.id,
                      logo:
                          org.imageUrls!.isNotEmpty ? org.imageUrls![0] : null,
                      name: org.name,
                      title: org.title,
                      tags: org.tags!.toList(),
                      press: () => Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: DetailsArguments(
                          organization: org,
                          index: snapshot.data!.indexOf(org),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
