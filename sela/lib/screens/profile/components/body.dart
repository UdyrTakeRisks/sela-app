import 'package:flutter/material.dart';
import 'package:sela/size_config.dart';
import 'package:sela/utils/colors.dart';

import '../../../models/user_model.dart';
import 'help_center.dart';
import 'my_account_page.dart';
import 'profile_menu.dart';
import 'profile_pic.dart';
import 'profile_services.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  late Future<Users> futureUserDetails;

  @override
  void initState() {
    super.initState();
    futureUserDetails = ProfileServices.fetchUserDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: FutureBuilder<Users>(
        future: futureUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load user details'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user details found'));
          } else {
            Users user = snapshot.data!;
            return Column(
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
                  child: const ProfilePic(),
                ),
                SizedBox(height: getProportionateScreenHeight(10)),
                Text(
                  user.name,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  user.username
                      .replaceAll(RegExp(r'\s+'), '')
                      .toLowerCase()
                      .trim(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                ProfileMenu(
                  text: "My Account",
                  icon: Icons.person,
                  press: () =>
                      Navigator.pushNamed(context, MyAccountPage.routeName),
                ),
                ProfileMenu(
                  text: "Notifications",
                  icon: Icons.notifications,
                  press: () {},
                ),
                ProfileMenu(
                  text: "Help Center",
                  icon: Icons.help,
                  press: () =>
                      Navigator.pushNamed(context, HelpCenterPage.routeName),
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
    );
  }
}
