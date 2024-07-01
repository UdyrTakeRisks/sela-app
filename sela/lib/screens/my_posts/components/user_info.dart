import 'package:flutter/material.dart';

import '../../../utils/colors.dart';

class UserInfo extends StatelessWidget {
  final String userName;
  final String userImage;
  final bool isOnline; // New property to determine online status

  const UserInfo({
    Key? key,
    required this.userName,
    required this.userImage,
    this.isOnline = true, // Default to offline
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Stack(
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
                  radius: 40,
                  backgroundColor: primaryColor,
                  child: userImage.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            userImage,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 50,
                          color: Colors.white,
                        ),
                ),
              ),
              Positioned(
                right: 4,
                bottom: 4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isOnline ? Colors.green : Colors.grey,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 8),
                Text(
                  "View Profile",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
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
