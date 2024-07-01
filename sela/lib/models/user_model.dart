// user_model.dart
class Users {
  final int userId;
  final String userPhoto;
  final String username;
  final String name;
  final String email;
  final String phone;

  Users({
    required this.userId,
    required this.userPhoto,
    required this.username,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json['user_id'],
      userPhoto: json['userPhoto'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      phone: json['phoneNumber'],
    );
  }
}
