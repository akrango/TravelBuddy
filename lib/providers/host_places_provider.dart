import 'package:airbnb_app/services/host_service.dart';
import 'package:flutter/material.dart';
import 'package:airbnb_app/models/place.dart';

class HostPlacesProvider with ChangeNotifier {
  List<Place> _hostPlaces = [];

  List<Place> get hostPlaces => _hostPlaces;
  final HostService _hostService = HostService();

  Future<void> fetchHostPlaces({required bool isHost}) async {
    try {
      _hostPlaces.clear();
      List<Place> fetchedPlaces = await _hostService.fetchHostPlaces(isHost: isHost);
      _hostPlaces.addAll(fetchedPlaces);
      notifyListeners();
    } catch (e) {
      print("Error fetching places: $e");
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
      await _hostService.savePlace(
        title: title,
        price: price,
        address: address,
        description: description,
        maxPeople: maxPeople,
        bedAndBathroom: bedAndBathroom,
        latitude: latitude,
        longitude: longitude,
        imageUrls: imageUrls,
        amenities: amenities,
        categoryIds: categoryIds,
      );
      notifyListeners();
    } catch (e) {
      print("Error saving place: $e");
    }
  }
}
