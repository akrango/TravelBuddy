import 'package:airbnb_app/models/place.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PlaceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Place>> getPlaces() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('places').get();

      List<Place> listOfPlaces = await Future.wait(snapshot.docs.map((doc) async {
        return Place.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList());

      return listOfPlaces;
    } catch (e) {
      print("Error fetching places: $e");
      return [];
    }
  }

  Future<Place> getPlaceById(String id) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('places').doc(id).get();

      if (snapshot.exists) {
        return Place.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      } else {
        throw Exception('Place not found');
      }
    } catch (e) {
      print("Error fetching place by ID: $e");
      throw e;
    }
  }

  Future<List<Place>> findByCategory(String categoryId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('places')
          .where('categories', arrayContains: categoryId)
          .get();

      List<Place> placesByCategory = await Future.wait(snapshot.docs.map((doc) async {
        return Place.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList());

      return placesByCategory;
    } catch (e) {
      print("Error fetching places by category: $e");
      return [];
    }
  }
}
