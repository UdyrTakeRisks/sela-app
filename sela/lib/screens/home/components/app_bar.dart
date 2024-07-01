import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/env.dart';
import '../../profile/profile_screen.dart';

class AppBarWelcome extends StatefulWidget {
  const AppBarWelcome({super.key});

  @override
  State<AppBarWelcome> createState() => AppBarWelcomeState();
}

class AppBarWelcomeState extends State<AppBarWelcome> {
  late String _userName = "SELA"; // Default value
  late String _userPhotoUrl = "assets/images/profile.png"; // Default value

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('userName') ?? "SELA";
    String userPhotoUrl =
        prefs.getString('userPhotoUrl') ?? "assets/images/profile.jpg";

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
      }
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
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
            child: CircleAvatar(
              radius: 30,
              backgroundImage: _userPhotoUrl.startsWith('http')
                  ? NetworkImage(_userPhotoUrl) as ImageProvider<Object>?
                  : AssetImage(_userPhotoUrl) as ImageProvider<Object>?,
              onBackgroundImageError: (_, __) {
                setState(() {
                  _userPhotoUrl = "assets/images/profile.png";
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
