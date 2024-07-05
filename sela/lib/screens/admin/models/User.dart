class User {
  final int userId;
  final String? userPhoto;
  final String username;
  final String name;
  final String email;
  final String? phoneNumber;

  User({
    required this.userId,
    this.userPhoto,
    required this.username,
    required this.name,
    required this.email,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      userPhoto: json['userPhoto'],
      username: json['username'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
