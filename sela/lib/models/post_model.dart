class Post {
  final List<String> imageUrls;
  final String name;
  final int type;
  final List<String> tags;
  final String title;
  final String description;
  final List<String> providers;
  final String about;
  final String socialLinks;

  Post({
    required this.imageUrls,
    required this.name,
    required this.type,
    required this.tags,
    required this.title,
    required this.description,
    required this.providers,
    required this.about,
    required this.socialLinks,
  });

  Map<String, dynamic> toJson() {
    return {
      'imageUrLs': imageUrls,
      'name': name,
      'type': type,
      'tags': tags,
      'title': title,
      'description': description,
      'providers': providers,
      'about': about,
      'socialLinks': socialLinks,
    };
  }

  @override
  String toString() {
    return toJson().toString();
  }
}
