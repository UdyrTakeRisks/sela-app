class Organization {
  final int id;
  final List<String> imageUrls;
  final String name;
  final List<String> tags;
  final String title;
  final String description;
  final List<String> providers;
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

// Our demo Products
//
// List<Organization> demoProducts = [
//   Organization(
//     id: 1,
//     images: [
//       "assets/images/yanfaa_1.png",
//       "assets/images/yanfaa_2.png",
//       "assets/images/yanfaa_3.png",
//       "assets/images/yanfaa_4.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     name: "Yanfaa",
//     title: "learning Organization",
//     price: 64.99,
//     description: description,
//     rating: 4.8,
//     isFavourite: true,
//     isPopular: true,
//     tags: ["Organization"],
//     requirement: "Requirement content goes here.",
//   ),
//   Organization(
//     id: 2,
//     images: [
//       "assets/images/Resala_1.png",
//       "assets/images/Resala_2.png",
//       "assets/images/Resala_3.png",
//       "assets/images/Resala_4.png",
//     ],
//     colors: [
//       Color(0xFFF6625E),
//       Color(0xFF836DB8),
//       Color(0xFFDECB9C),
//       Colors.white,
//     ],
//     name: "Resala",
//     title: "Resala Orgnaiztion",
//     price: 50.5,
//     description: description,
//     rating: 4.1,
//     isPopular: true,
//     tags: ["Organization"],
//     requirement: "Requirement content goes here.",
//   ),
// ];
//
// const String description =
//     "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
