import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:airbnb_app/models/place.dart';

class FavoriteProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<String> _favoriteIds = [];
  List<String> get favorites => _favoriteIds;

  FavoriteProvider() {
    loadFavorites();
  }

  String get _userId => _auth.currentUser?.uid ?? '';

  Future<void> toggleFavorite(Place place) async {
    if (_userId.isEmpty) return;

    String placeId = place.id;
    if (_favoriteIds.contains(placeId)) {
      await _removeFavorite(placeId);
    } else {
      await _addFavorite(placeId);
    }
    notifyListeners();
  }

  bool isExist(Place place) {
    return _favoriteIds.contains(place.id);
  }

  Future<void> _addFavorite(String placeId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(placeId)
          .set({'placeId': placeId});
      _favoriteIds.add(placeId);
    } catch (e) {
      print('Error adding favorite: $e');
    }
  }

  Future<void> _removeFavorite(String placeId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .doc(placeId)
          .delete();
      _favoriteIds.remove(placeId);
    } catch (e) {
      print('Error removing favorite: $e');
    }
  }

  Future<void> loadFavorites() async {
    if (_userId.isEmpty) return;

    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(_userId)
          .collection('favorites')
          .get();

      _favoriteIds = snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error loading favorites: $e');
    }
    notifyListeners();
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(context, listen: listen);
  }
}
