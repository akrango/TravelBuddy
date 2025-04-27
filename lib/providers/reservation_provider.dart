import 'package:airbnb_app/models/reservation.dart';
import 'package:airbnb_app/services/reservation_service.dart';
import 'package:flutter/material.dart';

class ReservationProvider with ChangeNotifier {
  final List<Reservation> _reservations = [];

  List<Reservation> get categories => [..._reservations];

  ReservationProvider() {
    _getUserReservations();
  }

  Future<void> _getUserReservations() async {
    final reservationService = ReservationService();
    final reservations = await reservationService.getUserReservations();
    _reservations.addAll(reservations);
    notifyListeners();
  }
}
