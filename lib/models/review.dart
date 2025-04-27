import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String id;
  final String userId;
  final String placeId;
  final String reviewText;
  final int rating;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.reviewText,
    required this.rating,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'placeId': placeId,
      'reviewText': reviewText,
      'rating': rating,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  static Review fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id ?? '',
      userId: map['userId'] ?? '',
      placeId: map['placeId'] ?? '',
      reviewText: map['reviewText'] ?? '',
      rating: map['rating'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
