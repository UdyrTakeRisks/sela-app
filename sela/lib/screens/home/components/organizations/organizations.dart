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
              print(snapshot.error);
              return Text("ERROR: ${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No Organizations Found");
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    ...snapshot.data!.map((org) => OrganizationCard(
                          index: org.id,
                          logo: org.imageUrls[0],
                          name: org.name,
                          title: org.title,
                          tags: org.tags
                              .take(3) // Take only the first 3 tags
                              .toList(),
                          press: () => Navigator.pushNamed(
                            context,
                            DetailsScreen.routeName,
                            arguments: DetailsArguments(
                              organization: org,
                              index: snapshot.data!.indexOf(org),
                            ),
                          ),
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
