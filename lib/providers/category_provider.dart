import 'package:airbnb_app/models/category.dart';
import 'package:airbnb_app/services/category_service.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final List<Category> _categories = [];

  List<Category> get categories => [..._categories];

  CategoryProvider() {
    _initializeCategories();
  }

  Future<void> _initializeCategories() async {
    final categoryService = CategoryService();
    final categories = await categoryService.getCategories();
    _categories.addAll(categories);
    notifyListeners();
  }
}
