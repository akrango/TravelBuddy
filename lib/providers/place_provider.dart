import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/services/place_service.dart';
import 'package:flutter/material.dart';

class PlaceProvider with ChangeNotifier {
  final List<Place> _places = [];

  List<Place> get places => _places;
  final PlaceService _placeService = PlaceService();

  PlaceProvider() {
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      List<Place> fetchedPlaces = await _placeService.getPlaces();
      _places.addAll(fetchedPlaces);
      notifyListeners();
    } catch (e) {
      print("Error fetching places: $e");
    }
  }

  Future<Place?> findById(String id) async {
    try {
      return await _placeService.getPlaceById(id);
    } catch (e) {
      print("Error fetching place by id: $e");
      return null;
    }
  }

  Future<List<Place>> findByCategory(String categoryId) async {
    return await _placeService.findByCategory(categoryId);
  }
}
