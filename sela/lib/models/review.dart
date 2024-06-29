class Review {
  final String username;
  final String description;
  final double rating;

  Review({
    required this.username,
    required this.description,
    required this.rating,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      username: json['username'],
      description: json['description'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
