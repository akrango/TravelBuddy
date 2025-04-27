import 'package:airbnb_app/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addReview(
      String userId, String placeId, String reviewText, int rating) async {
    try {
      await _firestore.collection('reviews').add({
        'userId': userId,
        'placeId': placeId,
        'reviewText': reviewText,
        'rating': rating,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding review: $e");
    }
  }

  Future<List<Review>> getReviewsForPlace(String placeId) async {
    try {
      QuerySnapshot reviewSnapshot = await _firestore
          .collection('reviews')
          .where('placeId', isEqualTo: placeId)
          .orderBy('createdAt', descending: true)
          .get();

      List<Review> reviews = reviewSnapshot.docs.map((doc) {
        return Review.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      return reviews;
    } catch (e) {
      print("Error fetching reviews for place: $e");
      return [];
    }
  }

  Future<double> getAverageRatingForPlace(String placeId) async {
    try {
      QuerySnapshot reviewSnapshot = await _firestore
          .collection('reviews')
          .where('placeId', isEqualTo: placeId)
          .get();

      double totalRating = 0;
      int reviewCount = reviewSnapshot.docs.length;

      for (var reviewDoc in reviewSnapshot.docs) {
        totalRating += reviewDoc['rating'];
      }

      if (reviewCount > 0) {
        return totalRating / reviewCount;
      } else {
        return 0.0;
      }
    } catch (e) {
      print("Error fetching reviews for place: $e");
      return 0.0;
    }
  }

  Future<String> fetchReviewerName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      String reviewerName = (userSnapshot.data() as Map<String, dynamic>?)?['displayName'] ??
          'Unknown User';
      return reviewerName;
    } catch (e) {
      print('Error fetching reviewer name: $e');
      return 'Unknown User';
    }
  }
}
