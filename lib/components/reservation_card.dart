import 'package:airbnb_app/models/reservation.dart';
import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/screens/place_details_screen.dart';
import 'package:airbnb_app/screens/reservation_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReservationCard extends StatelessWidget {
  final Reservation reservation;
  final Place place;

  const ReservationCard({
    super.key,
    required this.reservation,
    required this.place,
  });

  @override
  Widget build(BuildContext context) {
    final bool isReservationPassed = reservation.endDate.isBefore(DateTime.now());

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailScreen(place: place),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  
            children: [
            place.image.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      place.image,
                      width: double.infinity,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(Icons.location_on, size: 60),

            const SizedBox(height: 12),
            Text(
              'Reservation from ${DateFormat('yMMMd').format(reservation.startDate)} to ${DateFormat('yMMMd').format(reservation.endDate)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Text(
              place.title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Guests: ${reservation.numberOfPeople}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w300),
            ),
            const SizedBox(height: 16),
            if (isReservationPassed)
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationDetailScreen(
                        reservation: reservation,
                        place: place,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.rate_review, color: Colors.white),
                label: const Text("Leave Review", style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
          ],
        ),
      ),
    ));
  }
}
