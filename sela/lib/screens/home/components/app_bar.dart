import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/env.dart';
import '../../profile/profile_screen.dart';

class AppBarWelcome extends StatefulWidget {
  const AppBarWelcome({super.key});

  @override
  State<AppBarWelcome> createState() => _AppBarWelcomeState();
}

class _AppBarWelcomeState extends State<AppBarWelcome> {
  late String _userName = "SELA"; // Default value
  late String _userPhotoUrl = "assets/images/profile.png"; // Default value

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Fetch and cache name
      if (prefs.containsKey('userName')) {
        setState(() {
          _userName = prefs.getString('userName') ?? "SELA";
        });
      } else {
        final nameUrl = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/name');
        final nameResponse = await http.get(nameUrl, headers: {
          'Content-Type': 'application/json',
          'Cookie': prefs.getString('cookie') ?? '',
        });

        if (nameResponse.statusCode == 200) {
          setState(() {
            _userName = nameResponse.body;
          });
          await prefs.setString('userName', nameResponse.body);
        } else {
          throw Exception('Failed to load name');
        }
      }

      // Fetch and cache photo URL
      if (prefs.containsKey('userPhotoUrl')) {
        setState(() {
          _userPhotoUrl =
              prefs.getString('userPhotoUrl') ?? "assets/images/profile.png";
        });
      } else {
        final photoUrl = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/photo');
        final photoResponse = await http.get(photoUrl, headers: {
          'Content-Type': 'application/json',
          'Cookie': prefs.getString('cookie') ?? '',
        });

        if (photoResponse.statusCode == 200) {
          setState(() {
            _userPhotoUrl = photoResponse.body;
          });
          await prefs.setString('userPhotoUrl', photoResponse.body);
        } else {
          throw Exception('Failed to load photo');
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
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
            ),
          ),
        ],
      ),
    );
  }
}
