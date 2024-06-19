import 'package:flutter/material.dart';

class Product {
  final int id;
  final String title, description, category;
  final List<String> images;
  final List<Color> colors;
  final double rating, price;
  final bool isFavourite, isPopular;
  final List<String> tags;

  Product({
    required this.id,
    required this.images,
    required this.colors,
    this.rating = 0.0,
    this.isFavourite = false,
    this.isPopular = false,
    required this.title,
    required this.price,
    required this.description,
    this.category = "",
    this.tags = const [],
  });
}

// Our demo Products

List<Product> demoProducts = [
  Product(
    id: 1,
    images: [
      "assets/images/yanfaa_1.png",
      "assets/images/yanfaa_2.png",
      "assets/images/yanfaa_3.png",
      "assets/images/yanfaa_4.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Yanfaa",
    price: 64.99,
    description: description,
    rating: 4.8,
    isFavourite: true,
    isPopular: true,
    category: "Learning",
    tags: ["Organization"],
  ),
  Product(
    id: 2,
    images: [
      "assets/images/Resala_1.png",
      "assets/images/Resala_2.png",
      "assets/images/Resala_3.png",
      "assets/images/Resala_4.png",
    ],
    colors: [
      Color(0xFFF6625E),
      Color(0xFF836DB8),
      Color(0xFFDECB9C),
      Colors.white,
    ],
    title: "Resala",
    price: 50.5,
    description: description,
    rating: 4.1,
    isPopular: true,
    category: "Learning",
    tags: ["Organization"],
  ),
];

const String description =
    "Wireless Controller for PS4™ gives you what you want in your gaming from over precision control your games to sharing …";
