import 'package:airbnb_app/providers/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:airbnb_app/models/place.dart';
import 'package:provider/provider.dart';

class HostPlacesProvider with ChangeNotifier {
  List<Place> _hostPlaces = [];

  List<Place> get hostPlaces => _hostPlaces;

  Future<void> fetchHostPlaces(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (!userProvider.isHost) return;

      final snapshot = await FirebaseFirestore.instance
          .collection('places')
          .where('hostId', isEqualTo: user.uid)
          .get();

      final places = await Future.wait(snapshot.docs.map((doc) async {
        final data = doc.data();
        return Place.fromMap(data, doc.id);
      }).toList());

      _hostPlaces = places;
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching host places: $e');
    }
  }
}
