import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:airbnb_app/models/place.dart';

class FavoriteProvider extends ChangeNotifier {
  List<String> _favoriteIds = [];
  List<String> get favorites => _favoriteIds;

  FavoriteProvider() {
    loadFavorite();
  }

  void toggleFavorite(Place place) async {
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _favoriteIds.add(placeId);
      await prefs.setStringList('favorites', _favoriteIds);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _removeFavorite(String placeId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _favoriteIds.remove(placeId);
      await prefs.setStringList('favorites', _favoriteIds);
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadFavorite() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _favoriteIds = prefs.getStringList('favorites') ?? [];
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  static FavoriteProvider of(BuildContext context, {bool listen = true}) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  }
}
