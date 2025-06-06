import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/services/place_service.dart';
import 'package:flutter/material.dart';

class PlaceProvider with ChangeNotifier {
  final List<Place> _places = [];
  final Map<String, Place> _placesById = {};
  final PlaceService _placeService = PlaceService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List<Place> get places => _places;

  PlaceProvider() {
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    try {
      _isLoading = true;
      notifyListeners();

      List<Place> fetchedPlaces = await _placeService.getPlaces();

      _places.clear();
      _placesById.clear();

      _places.addAll(fetchedPlaces);
      for (var place in fetchedPlaces) {
        _placesById[place.id] = place;
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
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

  Place? findCachedById(String id) => _placesById[id];
}
