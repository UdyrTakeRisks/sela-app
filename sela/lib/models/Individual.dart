// lib/models/individual.dart

class Individual {
  final int postId;
  final List<String>? imageUrls;
  final String name;
  final String type;
  final List<String> tags;
  final String title;
  final String description;
  final List<String> providers;
  final String about;
  final String socialLinks;

  Individual({
    required this.postId,
    this.imageUrls,
    required this.name,
    required this.type,
    required this.tags,
    required this.title,
    required this.description,
    required this.providers,
    required this.about,
    required this.socialLinks,
  });

  factory Individual.fromJson(Map<String, dynamic> json) {
    return Individual(
      postId: json['post_id'],
      imageUrls: List<String>.from(json['imageUrLs']),
      name: json['name'],
      type: json['type'],
      tags: List<String>.from(json['tags']),
      title: json['title'],
      description: json['description'],
      providers: List<String>.from(json['providers']),
      about: json['about'],
      socialLinks: json['socialLinks'],
    );
  }
}
