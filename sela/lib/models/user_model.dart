// user_model.dart
class User {
  final int userId;
  final String userPhoto;
  final String username;
  final String name;
  final String email;

  User({
    required this.userId,
    required this.userPhoto,
    required this.username,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userPhoto: json['userPhoto'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
    );
  }
}
