import 'package:airbnb_app/components/reservation_card.dart';
import 'package:flutter/material.dart';
import 'package:airbnb_app/models/reservation.dart';
import 'package:airbnb_app/services/reservation_service.dart';
import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/services/place_service.dart';

class ReservationsListScreen extends StatefulWidget {
  @override
  _ReservationsListScreenState createState() => _ReservationsListScreenState();
}

class _ReservationsListScreenState extends State<ReservationsListScreen> {
  List<Reservation> reservations = [];
  bool isLoading = true;
  Map<String, Place> places = {};

  @override
  void initState() {
    super.initState();
    _fetchUserReservations();
  }

  Future<void> _fetchUserReservations() async {
    final reservationService = ReservationService();
    List<Reservation> fetchedReservations =
        await reservationService.getUserReservations();

    for (var reservation in fetchedReservations) {
      if (!places.containsKey(reservation.placeId)) {
        final placeService = PlaceService();
        Place place = await placeService.getPlaceById(reservation.placeId);
        places[reservation.placeId] = place;
      }
    }

    setState(() {
      reservations = fetchedReservations;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Reservations",
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reservations.isEmpty
              ? const Center(
                  child: Text(
                    "You don’t have any reservations yet.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: reservations.length,
                    itemBuilder: (context, index) {
                      final reservation = reservations[index];
                      final place = places[reservation.placeId];
                      if (place == null) {
                        return const SizedBox.shrink();
                      }

                      return ReservationCard(
                        reservation: reservation,
                        place: place,
                      );
                    },
                  ),
                ),
    );
  }
}
