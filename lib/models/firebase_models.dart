import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProduct {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final bool isNew;
  final int stock;
  final List<String> categories;
  final Timestamp createdAt;

  FirebaseProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.rating,
    required this.isNew,
    required this.stock,
    required this.categories,
    required this.createdAt,
  });
  factory FirebaseProduct.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FirebaseProduct(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      rating: (data['rating'] ?? 0).toDouble(),
      isNew: data['isNew'] ?? false,
      stock: data['stock'] ?? 0,
      categories: List<String>.from(data['categories'] ?? []),
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'rating': rating,
      'isNew': isNew,
      'stock': stock,
      'categories': categories,
      'createdAt': createdAt,
    };
  }
}
