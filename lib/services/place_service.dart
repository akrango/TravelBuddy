import 'package:airbnb_app/models/place.dart';

class PlaceService {
  List<Place> getPlaces() {
    return listOfPlaces;
  }

  Place getPlaceById(String id) {
    return listOfPlaces.firstWhere((element) => element.id == id);
  }

  List<Place> findByCategory(String categoryId) {
    return listOfPlaces.where((element) => element.categories.contains(categoryId)).toList();
  }
}
