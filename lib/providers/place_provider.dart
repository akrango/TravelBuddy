import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/services/place_service.dart';
import 'package:flutter/material.dart';

class PlaceProvider with ChangeNotifier {
  final List<Place> _places = [];
  final PlaceService _placeService = PlaceService();

  List<Place> get places => [..._places];

  PlaceProvider() {
    final placeService = PlaceService();
    _places.addAll(placeService.getPlaces());
    notifyListeners();
  }

  Place? findById(String id) {
    return _placeService.getPlaceById(id);
  }

  List<Place> findByCategory(String categoryId) {
    return _placeService.findByCategory(categoryId);
  }
}
