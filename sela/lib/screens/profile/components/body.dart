import 'package:flutter/material.dart';
import 'package:sela/size_config.dart';
import 'package:sela/utils/colors.dart';

import '../../../models/user_model.dart';
import '../../saved/saved_screen.dart';
import 'help_center.dart';
import 'my_account_page.dart';
import 'profile_menu.dart';
import 'profile_services.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<String> futureUserPhoto;
  late Future<Users> futureUserDetails;
  final bool _isOnline = true; // Online state indicator

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      futureUserDetails = ProfileServices.fetchUserDetails(context);
      futureUserPhoto = ProfileServices.fetchPhoto(context);
    });
    await Future.delayed(const Duration(seconds: 1));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Refreshed')),
    );
  }

  void fetchData() {
    futureUserDetails = ProfileServices.fetchUserDetails(context);
    futureUserPhoto = ProfileServices.fetchPhoto(context);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: primaryColor,
      backgroundColor: backgroundColor4,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            FutureBuilder<String>(
              future: futureUserPhoto,
              builder: (context, photoSnapshot) {
                if (photoSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                    semanticsLabel: 'Loading user photo',
                    semanticsValue: 'Loading user photo',
                  ));
                } else if (photoSnapshot.hasError) {
                  return CircleAvatar(
                    radius: 57.5,
                    backgroundColor: backgroundColor4,
                    child: const Icon(
                      Icons.person,
                      size: 57.5,
                      color: Colors.grey,
                    ),
                  );
                } else {
                  String userPhoto = photoSnapshot.data ?? "";
                  return Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: primaryColor,
                            width: 6,
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 4,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: userPhoto.startsWith('http')
                                ? Image.network(
                                    userPhoto,
                                    width: getProportionateScreenWidth(115),
                                    height: getProportionateScreenHeight(115),
                                    fit: BoxFit.cover,
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 115,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        bottom: 10,
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isOnline ? Colors.green : Colors.grey,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            SizedBox(height: getProportionateScreenHeight(10)),
            FutureBuilder<Users>(
              future: futureUserDetails,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: primaryColor,
                    semanticsLabel: 'Loading user details',
                    semanticsValue: 'Loading user details',
                  ));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load user details'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No user details found'));
                } else {
                  Users user = snapshot.data!;
                  return Column(
                    children: [
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "@${user.username}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                      ProfileMenu(
                        text: "My Account",
                        icon: Icons.person,
                        press: () => Navigator.pushNamed(
                          context,
                          MyAccountPage.routeName,
                        ),
                        color: primaryColor,
                      ),
                      ProfileMenu(
                        text: "Saved Posts",
                        icon: Icons.bookmark,
                        press: () => Navigator.pushNamed(
                          context,
                          SavedScreen.routeName,
                        ),
                        color: primaryColor,
                      ),
                      ProfileMenu(
                        text: "Help Center",
                        icon: Icons.help,
                        press: () => Navigator.pushNamed(
                          context,
                          HelpCenterPage.routeName,
                        ),
                        color: primaryColor,
                      ),
                      ProfileMenu(
                        text: "Log Out",
                        icon: Icons.logout,
                        press: () {
                          ProfileServices.logout(context);
                        },
                        color: primaryColor,
                      ),
                      ProfileMenu(
                        text: "Delete Account",
                        icon: Icons.delete_rounded,
                        press: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Delete Account"),
                                content: const Text(
                                    "Are you sure you want to delete your account?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await ProfileServices.deleteAccount(
                                          context);
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        color: Colors.redAccent,
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
