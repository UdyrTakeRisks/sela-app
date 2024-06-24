import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Replace this with actual user data
    final userName = "John Doe";
    final userImage =
        "https://ihaofykdrzgouxpitrvi.supabase.co/storage/v1/object/public/postimages/yanfaa/images/yanfaa_1.png?t=2024-06-22T21%3A49%3A56.889Z"; // Replace with actual URL or asset path

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(userImage),
          ),
          SizedBox(width: 16),
          Text(
            userName,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
