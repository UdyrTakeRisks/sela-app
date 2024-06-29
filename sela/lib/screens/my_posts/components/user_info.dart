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
            backgroundImage: userImage.isEmpty
                ? NetworkImage(
                    'https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png')
                : NetworkImage(userImage),
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
