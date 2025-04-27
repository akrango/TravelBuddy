import 'package:airbnb_app/models/place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:airbnb_app/models/reservation.dart';
import 'package:intl/intl.dart';
import 'package:airbnb_app/services/review_service.dart'; 

class ReservationDetailScreen extends StatefulWidget {
  final Reservation reservation;
  final Place place;

  const ReservationDetailScreen({
    Key? key,
    required this.reservation,
    required this.place,
  }) : super(key: key);

  @override
  _ReservationDetailScreenState createState() =>
      _ReservationDetailScreenState();
}

class _ReservationDetailScreenState extends State<ReservationDetailScreen> {
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 1;
  bool isReviewing = false;
  final user = FirebaseAuth.instance.currentUser;
  final ReviewService _reviewService = ReviewService();

  @override
  Widget build(BuildContext context) {
    bool isPastReservation =
        widget.reservation.endDate.isBefore(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reservation Details"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade50,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.place.title,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Image.network(widget.place.image ?? ""),
                  const SizedBox(height: 12),
                  Text(
                    widget.place.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Reservation Details',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'From: ${DateFormat('yMMMd').format(widget.reservation.startDate)}\n'
              'To: ${DateFormat('yMMMd').format(widget.reservation.endDate)}\n'
              'Guests: ${widget.reservation.numberOfPeople}',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 20),
            if (isPastReservation && !isReviewing)
              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isReviewing = true;
                  });
                },
                icon: const Icon(Icons.rate_review, color: Colors.white),
                label: const Text("Leave Review",
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            if (isReviewing)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  TextField(
                    controller: _reviewController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: 'Write your review',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Rating:"),
                  Slider(
                    value: _rating.toDouble(),
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: '$_rating',
                    onChanged: (double value) {
                      setState(() {
                        _rating = value.toInt();
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await _reviewService.addReview(
                          user?.uid ?? "",
                          widget.place.id,
                          _reviewController.text,
                          _rating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Review submitted successfully!')),
                        );
                        setState(() {
                          isReviewing = false;
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('Error submitting review: $e')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      "Submit Review",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
