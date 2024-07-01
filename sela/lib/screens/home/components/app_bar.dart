import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/env.dart';
import '../../profile/profile_screen.dart';

class AppBarWelcome extends StatelessWidget {
  const AppBarWelcome({super.key});

  Future<Map<String, String>> _fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userName = prefs.getString('userName') ?? "SELA";
    String userPhotoUrl =
        prefs.getString('userPhotoUrl') ?? "Assets/images/profile.png";

    try {
      // Fetch name
      final nameUrl = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/name');
      final nameResponse = await http.get(nameUrl, headers: {
        'Content-Type': 'application/json',
        'Cookie': prefs.getString('cookie') ?? '',
      });

      if (nameResponse.statusCode == 200) {
        userName = nameResponse.body;
        await prefs.setString('userName', userName);
      }

      // Fetch photo URL
      final photoUrl = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/photo');
      final photoResponse = await http.get(photoUrl, headers: {
        'Content-Type': 'application/json',
        'Cookie': prefs.getString('cookie') ?? '',
      });

      if (photoResponse.statusCode == 200) {
        userPhotoUrl = photoResponse.body;
        await prefs.setString('userPhotoUrl', userPhotoUrl);
      }
    } catch (e) {
      print('Error fetching data: $e');
    }

    return {
      'userName': userName,
      'userPhotoUrl': userPhotoUrl,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, String>>(
      future: _fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching data'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No data available'));
        }

        final data = snapshot.data!;
        final userName = data['userName']!;
        final userPhotoUrl = data['userPhotoUrl']!;

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
                        "$userName! 👋",
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
                  backgroundImage: userPhotoUrl.startsWith('https')
                      ? NetworkImage(userPhotoUrl) as ImageProvider<Object>?
                      : AssetImage(userPhotoUrl) as ImageProvider<Object>?,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
