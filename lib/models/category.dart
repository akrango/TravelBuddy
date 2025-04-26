
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  final String id;
  final String title;
  final String image;

  Category({
    required this.id,
    required this.title,
    required this.image,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'image': image,
    };
  }

  static Category fromMap(Map<String, dynamic> data, String documentId) {
    return Category(
      id: documentId,
      title: data['title'] as String,
      image: data['image'] as String,
    );
  }
}

Future<void> saveCategoriesToFirebase() async {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("categories");

  for (var category in categoriesList) {
    // final String id =
    //     DateTime.now().toIso8601String() + Random().nextInt(1000).toString();
    ref.doc("das");
    await ref.add(category.toMap());
  }
}

final List<Category> categoriesList = [
  Category(
    id: "1", // H0NpnGhsEz1uxAF0Vfbc
    title: "Rooms",
    image: "https://cdn-icons-png.flaticon.com/512/6192/6192020.png",
  ),
  Category(
    id: "2", //5yTBSMZtBQdkJuoX1aDJ
    title: "Beach",
    image: "https://static.thenounproject.com/png/384446-200.png",
  ),
  Category(
    id: "3", //IDE65G02FUF4clXrxvdm
    title: "Luxury",
    image: "https://cdn-icons-png.freepik.com/512/48/48781.png",
  ),
  Category(
    id: "4", //AGr8YW6K9rwUfKa79b86
    title: "Mountains",
    image: "https://cdn-icons-png.freepik.com/512/98/98527.png",
  ),
  Category(
    id: "5", //BEL2cIcykrfUs0fz0TL3
    title: "Ocean",
    image: "https://static.thenounproject.com/png/5027454-200.png",
  ),
  Category(
    id: "6", //U3h9p9o08sCfeo8CNNCk
    title: "New",
    image: "https://www.iconpacks.net/icons/1/free-key-icon-920-thumb.png",
  ),
  Category(
    id: "7", //zAJCKZ6yPWgW4v3GKDNj
    title: "Design",
    image: "https://cdn-icons-png.freepik.com/512/98/98527.png",
  ),
];
