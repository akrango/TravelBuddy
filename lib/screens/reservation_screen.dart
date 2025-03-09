import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/reservation.dart';

class ReservationScreen extends StatefulWidget {
  final String placeId;

  const ReservationScreen({Key? key, required this.placeId}) : super(key: key);

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<DateTime> _unavailableDates = [];

  @override
  void initState() {
    super.initState();
    _fetchUnavailableDates();
  }

  Future<void> _fetchUnavailableDates() async {
    final reservations = await FirebaseFirestore.instance
        .collection('reservations')
        .where('placeId', isEqualTo: widget.placeId)
        .get();

    setState(() {
      _unavailableDates = reservations.docs.expand((doc) {
        final data = doc.data();
        final start = (data['startDate'] as Timestamp).toDate();
        final end = (data['endDate'] as Timestamp).toDate();
        return List.generate(end.difference(start).inDays + 1,
            (index) => start.add(Duration(days: index)));
      }).toList();
    });
  }

  bool _isDateUnavailable(DateTime day) {
    return _unavailableDates.any((date) => isSameDay(date, day));
  }

  Future<void> _saveReservation() async {
    if (_startDate == null || _endDate == null) return;
    final FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    final uid = currentUser!.uid;

    final reservation = Reservation(
      id: FirebaseFirestore.instance.collection('reservations').doc().id,
      placeId: widget.placeId,
      userId: uid,
      startDate: _startDate!,
      endDate: _endDate!,
      numberOfPeople: 2,
    );

    await FirebaseFirestore.instance
        .collection('reservations')
        .doc(reservation.id)
        .set(reservation.toMap());

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Reservation successful!')));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Dates')),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: DateTime.now(),
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            selectedDayPredicate: (day) =>
                isSameDay(_startDate, day) || isSameDay(_endDate, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (_startDate == null ||
                    (selectedDay.isBefore(_startDate!) || _endDate != null)) {
                  _startDate = selectedDay;
                  _endDate = null;
                } else {
                  _endDate = selectedDay;
                }
              });
            },
            calendarStyle: CalendarStyle(
              disabledDecoration: const BoxDecoration(color: Colors.grey),
              outsideTextStyle: const TextStyle(color: Colors.white),
            ),
            enabledDayPredicate: (day) => !_isDateUnavailable(day),
          ),
          ElevatedButton(
            onPressed: (_startDate != null && _endDate != null)
                ? _saveReservation
                : null,
            child: const Text('Confirm Reservation'),
          ),
        ],
      ),
    );
  }
}
