import 'package:flutter/material.dart';
import 'package:sela/models/Organizations.dart';
import 'package:sela/screens/details/details_screen.dart';
import 'package:sela/size_config.dart';

import '../../../../utils/colors.dart';
import '../search_field.dart';
import 'all_organization_card.dart';
import 'organization_service.dart';

class AllOrganizationsScreen extends StatefulWidget {
  static String routeName = "/all_organizations";

  const AllOrganizationsScreen({super.key});

  @override
  _AllOrganizationsScreenState createState() => _AllOrganizationsScreenState();
}

class _AllOrganizationsScreenState extends State<AllOrganizationsScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Organization>> futureOrganizations;

  bool isMostRecent = true;

  @override
  void initState() {
    super.initState();
    futureOrganizations = OrganizationService().fetchOrganizations();
  }

  void toggleSortOrder() {
    setState(() {
      isMostRecent = !isMostRecent;
    });
  }

  void mySaved() {
    Navigator.pushNamed(context, '/saved');
  }

  void createPost() {
    Navigator.pushNamed(context, '/create_post');
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("All Organizations"),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            left: getProportionateScreenWidth(20),
            right: getProportionateScreenWidth(20),
            bottom: getProportionateScreenWidth(20),
            top: getProportionateScreenWidth(10),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(getProportionateScreenWidth(20)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: primaryColor.withOpacity(0.1),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: getProportionateScreenHeight(10),
                    ),
                    const SearchField(),
                    SizedBox(
                      height: getProportionateScreenHeight(20),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ToggleButtons(
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          borderWidth: 1,
                          borderRadius: BorderRadius.circular(10),
                          selectedColor: Colors.white,
                          fillColor: primaryColor,
                          isSelected: [isMostRecent, !isMostRecent],
                          onPressed: (index) {
                            toggleSortOrder();
                          },
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(15)),
                              child: const Text("Most Recent"),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getProportionateScreenWidth(15)),
                              child: const Text("Newest"),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit_note),
                              onPressed: createPost,
                            ),
                            IconButton(
                              icon: const Icon(Icons.bookmark),
                              onPressed: mySaved,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: getProportionateScreenHeight(10),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Expanded(
                child: FutureBuilder<List<Organization>>(
                  future: futureOrganizations,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("ERROR: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                          child: Text("No Organizations Found"));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          var org = snapshot.data![index];
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: getProportionateScreenWidth(10),
                            ),
                            child: NewOrganizationCard(
                              organization: org,
                              press: () => Navigator.pushNamed(
                                context,
                                DetailsScreen.routeName,
                                arguments: DetailsArguments(
                                  organization: org,
                                  index: index,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
