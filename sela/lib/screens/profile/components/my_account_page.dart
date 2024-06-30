import 'package:flutter/material.dart';
import 'package:sela/size_config.dart';
import 'package:sela/utils/colors.dart';

import '../../../models/user_model.dart';
import 'edit_profile_field.dart'; // Custom widget for editable fields
import 'profile_services.dart';

class MyAccountPage extends StatefulWidget {
  const MyAccountPage({super.key});

  static String routeName = "/my_account";

  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> {
  late Future<String> futureProfilePhotoUrl;
  late Future<User> futureUserDetails = ProfileServices.fetchUserDetails();

  @override
  void initState() {
    super.initState();
    futureProfilePhotoUrl = ProfileServices.fetchProfilePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        scrolledUnderElevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<User>(
        future: futureUserDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Failed to load user details'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user details found'));
          } else {
            User user = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.elliptical(600, 300),
                      ),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(30),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.userPhoto),
                                    backgroundColor: Colors.grey[200],
                                    radius: 50,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 15,
                                right: 15,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: buttonColor.withOpacity(0.8),
                                  ),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      // Implement the edit picture functionality
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          user.name,
                          style: TextStyle(
                            shadows: [
                              Shadow(
                                color: backgroundColor4,
                                blurRadius: 10,
                              ),
                            ],
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontFeatures: const [
                              FontFeature.enable('smcp'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, bottom: 30),
                    child: Column(
                      children: [
                        EditProfileField(
                          label: 'Username',
                          value: user.username,
                          onPressed: () {
                            // Implement the edit functionality
                          },
                        ),
                        EditProfileField(
                          label: 'Name',
                          value: user.name,
                          onPressed: () {
                            // Implement the edit functionality
                          },
                        ),
                        EditProfileField(
                          label: 'Email',
                          value: user.email,
                          onPressed: () {
                            // Implement the edit functionality
                          },
                        ),
                        EditProfileField(
                          label: 'Phone Number',
                          value:
                              '+1234567890', // Static value until the API is updated
                          onPressed: () {
                            // Implement the edit functionality
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
