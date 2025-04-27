import 'package:airbnb_app/models/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReservationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Reservation>> getUserReservations() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('reservations')
          .where('userId', isEqualTo: user.uid)
          .get();

      List<Reservation> reservationsList = snapshot.docs.map((doc) {
        return Reservation.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return reservationsList;
    } catch (e) {
      print("Error fetching reservations: $e");
      return [];
    }
  }
}
