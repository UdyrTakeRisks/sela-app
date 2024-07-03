import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sela/screens/profile/components/my_account_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../../../utils/colors.dart';
import '../../../utils/env.dart';
import '../../sign_in/sign_in_screen.dart';

class AppBarWelcome extends StatefulWidget {
  const AppBarWelcome({super.key});

  @override
  State<AppBarWelcome> createState() => AppBarWelcomeState();
}

class AppBarWelcomeState extends State<AppBarWelcome> {
  String _userName = "SELA"; // Default value
  String _userPhotoUrl = ""; // Default value
  bool _isOnline = true; // Online state indicator

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String userName = prefs.getString('userName') ?? "SELA";
    String userPhotoUrl = prefs.getString('userPhotoUrl') ?? "";

    try {
      // Fetch name
      final nameUrl = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/name');
      final nameResponse = await http.get(nameUrl, headers: {
        'Content-Type': 'application/json',
        'Cookie': prefs.getString('cookie') ?? '',
      });

      if (nameResponse.statusCode == 200 && nameResponse.body.isNotEmpty) {
        userName = nameResponse.body;
        await prefs.setString('userName', userName);
      }

      // Fetch photo URL
      final photoUrl = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/photo');
      final photoResponse = await http.get(photoUrl, headers: {
        'Content-Type': 'application/json',
        'Cookie': prefs.getString('cookie') ?? '',
      });

      if (photoResponse.statusCode == 200 && photoResponse.body.isNotEmpty) {
        userPhotoUrl = photoResponse.body;
        await prefs.setString('userPhotoUrl', userPhotoUrl);
      } else {
        userPhotoUrl = ""; // Set to empty string if response is null or empty
        await prefs.remove('userPhotoUrl'); // Remove invalid URL from prefs
      }

      // Simulate online status (replace with actual logic if available)
      _isOnline = true; // Set online status to true
    } catch (e) {
      print('Error fetching data: $e');
    }

    setState(() {
      _userName = userName;
      _userPhotoUrl = userPhotoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> isCookie() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? expirationTimestamp =
          prefs.getString('cookieExpirationTimestamp');
      if (expirationTimestamp == null) {
        return false; // No timestamp means the cookie is not valid
      }
      DateTime expirationDate = DateTime.parse(expirationTimestamp);
      return DateTime.now().isBefore(expirationDate);
    }

    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "SELA",
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  fontFamily: "poppins",
                ),
              ),
              Row(
                children: [
                  const Text(
                    "Welcome Back, ",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF95969D),
                    ),
                  ),
                  Text(
                    "$_userName! 👋",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                      fontFamily: "poppins",
                    ),
                  ),
                ],
              )
            ],
          ),
          GestureDetector(
            onTap: () async {
              bool isHasCookie = await isCookie();
              if (!isHasCookie) {
                toastification.showCustom(
                  context: context,
                  autoCloseDuration: const Duration(seconds: 5),
                  alignment: Alignment.topRight,
                  builder: (BuildContext context, ToastificationItem holder) {
                    return Container(
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: primaryColor.withOpacity(0.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            color: primaryColor.withOpacity(0.2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Please Sign In',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Please create an account to access this feature.',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        // Navigate to sign-in screen
                                        Navigator.pushNamed(
                                            context, SignInScreen.routeName);
                                      },
                                      child: const Text('Sign In'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
                return;
              } else {
                Navigator.pushNamed(context, MyAccountPage.routeName);
              }
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: primaryColor,
                      width: 2,
                    ),
                  ),
                  padding: const EdgeInsets.all(2),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: primaryColor,
                    child: ClipOval(
                      child: _userPhotoUrl.isNotEmpty
                          ? Image.network(
                              _userPhotoUrl,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.person,
                                  size: 60,
                                  color: primaryColor,
                                );
                              },
                            )
                          : const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    width: 16,
                    height: 16,
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
            ),
          ),
        ],
      ),
    );
  }
}
