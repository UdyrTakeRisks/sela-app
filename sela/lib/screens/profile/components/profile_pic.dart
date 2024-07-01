import 'package:flutter/material.dart';
import 'package:sela/utils/colors.dart';

import 'profile_services.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  late Future<String> futureProfilePhotoUrl;

  @override
  void initState() {
    super.initState();
    futureProfilePhotoUrl = ProfileServices.fetchProfilePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: futureProfilePhotoUrl,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircleAvatar(
            backgroundColor: backgroundColor4,
            radius: 57.5,
            child: const CircularProgressIndicator(),
          );
        } else if (snapshot.hasError ||
            !snapshot.hasData ||
            snapshot.data!.isEmpty) {
          return CircleAvatar(
            backgroundImage: const AssetImage("assets/images/profile.png"),
            backgroundColor: backgroundColor4,
            radius: 57.5,
          );
        } else {
          return CircleAvatar(
            backgroundImage: NetworkImage(snapshot.data!),
            backgroundColor: backgroundColor4,
            radius: 57.5,
          );
        }
      },
    );
  }
}
