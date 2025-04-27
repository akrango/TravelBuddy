import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HostService {
  Future<List<Place>> fetchHostPlaces({required bool isHost}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      if (!isHost) return [];

      final snapshot = await FirebaseFirestore.instance
          .collection('places')
          .where('hostId', isEqualTo: user.uid)
          .get();

      final places = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        return Place.fromMap(data, doc.id);
      }).toList());

      return places;
    } catch (e) {
      print('Error fetching host places: $e');
      return [];
    }
  }

  Future<void> savePlace({
    required String title,
    required int price,
    required String address,
    required String description,
    required int maxPeople,
    required String bedAndBathroom,
    required double latitude,
    required double longitude,
    required List<String> imageUrls,
    required List<String> amenities,
    required List<String> categoryIds,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("No user logged in");

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception("User not found");
      }

      final userData =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

      await FirebaseFirestore.instance.collection('places').add({
        'title': title,
        'price': price,
        'address': address,
        'description': description,
        'hostId': user.uid,
        'maxPeople': maxPeople,
        'bedAndBathroom': bedAndBathroom,
        'latitude': latitude,
        'longitude': longitude,
        'image': imageUrls[0],
        'imageUrls': imageUrls,
        'amenities': amenities,
        'categories': categoryIds,
        'vendor': userData.displayName,
        'vendorProfile': userData.photoURL,
        'vendorProfession': userData.profession,
        'yearsOfHosting': userData.yearsOfHosting,
      });
    } catch (e) {
      print("Error in savePlace: $e");
      rethrow;
    }
  }
}
