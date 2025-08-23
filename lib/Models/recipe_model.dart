import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeModel {
  final String userId;
  final String recipeId;
  final String username;
  final String name;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final Map<String, String> nutritions;
  final String estimatedtime;
  final String ratings;
  final int items;
  final int steps;
  final String uploadedby;
  final List<Map<String, String>> ingredients;
  final List<String> instructions;
  final Timestamp? createdAt;

  RecipeModel({
    required this.userId,
    required this.recipeId,
    required this.username,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.estimatedtime,
    required this.ratings,
    required this.items,
    required this.steps,
    required this.uploadedby,
    required this.nutritions,
    required this.ingredients,
    required this.instructions,
    this.createdAt,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'recipeId': recipeId,
      'username': username,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'estimatedtime': estimatedtime,
      'ratings': ratings,
      'items': items,
      'steps': steps,
      'uploadedby': uploadedby,
      'nutritions': nutritions,
      'ingredients': ingredients,
      'instructions': instructions,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // Create from Firestore Document
  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      userId: map['userId'] ?? '',
      recipeId: map['recipeId'] ?? '',
      username: map['username'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      videoUrl: map['videoUrl'] ?? '',
      nutritions: Map<String, String>.from(map['nutritions'] ?? {}),
      ingredients: List<Map<String, String>>.from(
        (map['ingredients'] ?? []).map(
          (item) => Map<String, String>.from(item),
        ),
      ),
      instructions: List<String>.from(map['instructions'] ?? []),
      createdAt: map['createdAt'],
      estimatedtime: map['estimatedtime'],
      ratings: map['ratings'],
      items: map['items'],
      steps: map['steps'],
      uploadedby: map['uploadedby'],
    );
  }
}
