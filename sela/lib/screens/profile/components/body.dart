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
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<String> futureUserPhoto;
  late Future<Users> futureUserDetails;
  bool _isOnline = true; // Online state indicator

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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            FutureBuilder<String>(
              future: futureUserPhoto,
              builder: (context, photoSnapshot) {
                if (photoSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (photoSnapshot.hasError) {
                  return CircleAvatar(
                    radius: 57.5,
                    backgroundColor: backgroundColor4,
                    child: Icon(
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
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor,
                            ),
                          ],
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: primaryColor,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(2),
                          child: CircleAvatar(
                            radius: 57.5,
                            backgroundColor: primaryColor,
                            child: ClipOval(
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
                      ),
                      Positioned(
                        right: 6,
                        bottom: 6,
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
                  return const Center(child: CircularProgressIndicator());
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
                        "@${user.username.replaceAll(RegExp(r'\s+'), '').toLowerCase().trim()}",
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
                      ),
                      ProfileMenu(
                        text: "Saved Posts",
                        icon: Icons.bookmark,
                        press: () =>
                            Navigator.pushNamed(context, SavedScreen.routeName),
                      ),
                      ProfileMenu(
                        text: "Help Center",
                        icon: Icons.help,
                        press: () => Navigator.pushNamed(
                          context,
                          HelpCenterPage.routeName,
                        ),
                      ),
                      ProfileMenu(
                        text: "Log Out",
                        icon: Icons.logout,
                        press: () {
                          ProfileServices.logout(context);
                        },
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
