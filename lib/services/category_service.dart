import 'package:airbnb_app/models/category.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Category>> getCategories() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('categories').get();

      List<Category> categoriesList = snapshot.docs.map((doc) {
        return Category.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      return categoriesList;
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }
}
