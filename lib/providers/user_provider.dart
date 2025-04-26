import 'package:airbnb_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _role;

  String? get role => _role;

  UserModel? _user;

  Future<void> fetchUserRole() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        debugPrint("User is not logged in.");
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!doc.exists) {
        debugPrint("User document does not exist.");
        return;
      }
      _user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
      _role = doc.data()?['role'];
      debugPrint("User role fetched successfully: $_role");
      notifyListeners();
    } catch (e, stackTrace) {
      debugPrint('Error fetching user role: $e');
      debugPrint(stackTrace.toString());
    }
  }

  bool get isHost => _role == 'host';
  bool get isGuest => _role == 'guest';
  UserModel? get user => _user;
}
