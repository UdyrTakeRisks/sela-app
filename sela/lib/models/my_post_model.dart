class MyPost {
  final int postId;
  final List<String>? imageUrls;
  final String? name;
  final List<String>? tags;
  final String? title;
  final String? description;
  final List<String>? providers;
  final String? about;
  final String? socialLinks;

  MyPost({
    required this.postId,
    this.imageUrls,
    this.name,
    this.tags,
    this.title,
    this.description,
    this.providers,
    this.about,
    this.socialLinks,
  });

  factory MyPost.fromJson(Map<String, dynamic> json) {
    return MyPost(
      postId: json['post_id'] ?? 0,
      imageUrls: json['imageUrls'] != null
          ? List<String>.from(json['imageUrls'])
          : null,
      name: json['name'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      title: json['title'],
      description: json['description'],
      providers: json['providers'] != null
          ? List<String>.from(json['providers'])
          : null,
      about: json['about'],
      socialLinks: json['socialLinks'],
    );
  }
}
