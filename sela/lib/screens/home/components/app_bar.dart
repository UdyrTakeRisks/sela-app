import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/env.dart';
import '../../profile/profile_screen.dart';

class AppBarWelcome extends StatelessWidget {
  const AppBarWelcome({super.key});

  Future<String> _fetchPhoto() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('cookie');

    final url = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/photo');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      if (cookie != null) 'Cookie': cookie,
    });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load photo');
    }
  }

  Future<String> _fetchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cookie = prefs.getString('cookie');

    final url = Uri.parse('$DOTNET_URL_API_BACKEND/User/view/name');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      if (cookie != null) 'Cookie': cookie,
    });

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load name');
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
          FutureBuilder<String>(
            future: _fetchName(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SELA",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontFamily: "poppins",
                      ),
                    ),
                    Text(
                      "Welcome Back!👋",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF95969D),
                      ),
                    ),
                  ],
                );
              } else if (snapshot.hasError) {
                return const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SELA",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontFamily: "poppins",
                      ),
                    ),
                    Text(
                      "Welcome Back!👋",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF95969D),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "SELA",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontWeight: FontWeight.w900,
                        fontFamily: "poppins",
                      ),
                    ),
                    Text(
                      "Welcome Back, ${snapshot.data}!👋",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF95969D),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.routeName);
            },
            child: FutureBuilder<String>(
              future: _fetchPhoto(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  );
                } else if (snapshot.hasError) {
                  return const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  );
                } else {
                  return CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(snapshot.data!),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
