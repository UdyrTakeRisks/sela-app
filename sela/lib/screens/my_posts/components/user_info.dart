import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class UserInfo extends StatelessWidget {
  final String userName;
  final String userImage;

  const UserInfo({
    required this.userName,
    required this.userImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: backgroundColor2,
            // if there is no image, display the user's first letter
            backgroundImage: userImage.isNotEmpty
                ? NetworkImage(userImage)
                : const AssetImage('assets/images/profile.png')
                    as ImageProvider,
          ),
          const SizedBox(width: 16),
          Text(
            userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
