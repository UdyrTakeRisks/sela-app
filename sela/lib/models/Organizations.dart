class Organization {
  final int id;
  final List<String>? imageUrls;
  final int type;
  final String name;
  final List<String>? tags;
  final String title;
  final String description;
  final List<String>? providers;
  final String about;
  final String socialLinks;

  final double rating;

  bool isFavourite, isPopular;

  Organization({
    required this.id,
    required this.imageUrls,
    required this.name,
    required this.tags,
    required this.title,
    required this.description,
    required this.providers,
    required this.about,
    required this.socialLinks,
    this.type = 0,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
  });
  factory Organization.fromJson(Map<String, dynamic> json) {
    return Organization(
      id: json['post_id'],
      imageUrls: List<String>.from(json['imageUrLs']),
      name: json['name'],
      tags: List<String>.from(json['tags']),
      title: json['title'],
      description: json['description'],
      providers: List<String>.from(json['providers']),
      about: json['about'],
      socialLinks: json['socialLinks'],
    );
  }
}
