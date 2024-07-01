import 'package:flutter/material.dart';
import 'package:sela/models/individual.dart';
import 'package:sela/screens/details/details_screen.dart';
import 'package:sela/size_config.dart';

import '../../../../models/Organizations.dart';
import '../../../../utils/colors.dart';
import '../search_field.dart';
import 'all_individual_card.dart';
import 'individual_service.dart';

class AllIndividualsScreen extends StatefulWidget {
  static String routeName = "/all_individuals";

  const AllIndividualsScreen({super.key});

  @override
  _AllIndividualsScreenState createState() => _AllIndividualsScreenState();
}

class _AllIndividualsScreenState extends State<AllIndividualsScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Individual>> futureIndividuals;

  bool isMostRecent = true;

  @override
  void initState() {
    super.initState();
    futureIndividuals = IndividualService().fetchIndividuals();
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
          title: const Text("All Individuals"),
        ),
        body: RefreshIndicator(
          color: primaryColor,
          semanticsLabel: "Refresh Individuals",
          semanticsValue: "Refresh Individuals",
          onRefresh: () async {
            setState(() {
              futureIndividuals = IndividualService().fetchIndividuals();
            });
            // show a snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Refreshed Successfully"),
              ),
            );
          },
          child: Padding(
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
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(
                            context, SearchScreen.routeName),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 4),
                                blurRadius: 30,
                                color: primaryColor.withOpacity(0.23),
                              ),
                            ],
                          ),
                          child: Row(
                            children: const [
                              Icon(Icons.search),
                              SizedBox(width: 10),
                              Text('Search'),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: getProportionateScreenHeight(20),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: mySaved,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.bookmark,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "My Saved",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: createPost,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.add,
                                    color: primaryColor,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    "Create Post",
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                  child: FutureBuilder<List<Individual>>(
                    future: futureIndividuals,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("ERROR: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("No Individuals Found"));
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            var individual = snapshot.data![index];
                            // Convert Individual to Organization for DetailsScreen
                            var organization = Organization(
                              id: individual.postId,
                              name: individual.name,
                              title: individual.title,
                              description: individual.description,
                              imageUrls: individual.imageUrls,
                              type: individual.type == 'Organization' ? 0 : 1,
                              tags: individual.tags,
                              providers: individual.providers,
                              about: individual.about,
                              socialLinks: individual.socialLinks,
                            );
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: getProportionateScreenWidth(10),
                              ),
                              child: NewIndividualCard(
                                individual: individual,
                                press: () => Navigator.pushNamed(
                                  context,
                                  DetailsScreen.routeName,
                                  arguments: DetailsArguments(
                                    organization: organization,
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
      ),
    );
  }
}
