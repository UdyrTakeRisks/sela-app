import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sela/models/Organizations.dart';

import '../../../size_config.dart';
import '../../../utils/env.dart';
import '../../details/details_screen.dart';
import 'section_title.dart';

class Organizations extends StatefulWidget {
  const Organizations({
    super.key,
  });

  @override
  State<Organizations> createState() => _OrganizationsState();
}

class _OrganizationsState extends State<Organizations> {
  late Future<List<Organization>> futureOrganizations;

  @override
  void initState() {
    super.initState();
    futureOrganizations = fetchOrganizations();
  }

  Future<List<Organization>> fetchOrganizations() async {
    final response =
        await http.get(Uri.parse('$DOTNET_URL_API_BACKEND/Post/view/all/orgs'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((org) => Organization.fromJson(org))
          .take(5) // Take only the first 5 organizations
          .toList();
    } else {
      throw Exception('Failed to load organizations');
    }
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
            press: () {},
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

class OrganizationCard extends StatelessWidget {
  const OrganizationCard({
    Key? key,
    required this.logo,
    required this.name,
    required this.title,
    required this.tags,
    required this.press,
    required this.index,
  }) : super(key: key);

  final int index;
  final String logo, name, title;
  final List<String> tags;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: GestureDetector(
        onTap: press,
        child: Container(
          width: getProportionateScreenWidth(242),
          height: getProportionateScreenWidth(120),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/images/Mask.png"),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.screen,
              ),
            ),
            color: const Color(0xFF356899),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      logo,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // const IconButton(
                  //   onPressed: null,
                  //   icon: Icon(
                  //     Icons.bookmark,
                  //     color: Colors.white60,
                  //     size: 24,
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tag,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: "poppins",
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
