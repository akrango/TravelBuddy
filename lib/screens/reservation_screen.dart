import 'package:airbnb_app/models/place.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/reservation.dart';

class ReservationScreen extends StatefulWidget {
  final Place place;

  const ReservationScreen({super.key, required this.place});

  @override
  State<ReservationScreen> createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _startDate;
  DateTime? _endDate;
  List<DateTime> _unavailableDates = [];
  int _numberOfPeople = 1;

  @override
  void initState() {
    super.initState();
    _fetchUnavailableDates();
  }

  void _onFormatChanged(CalendarFormat format) {
    setState(() {
      _calendarFormat = format;
    });
  }

  Future<void> _fetchUnavailableDates() async {
    final reservations = await FirebaseFirestore.instance
        .collection('reservations')
        .where('placeId', isEqualTo: widget.place.id)
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
      placeId: widget.place.id,
      userId: uid,
      startDate: _startDate!,
      endDate: _endDate!,
      numberOfPeople: _numberOfPeople,
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
            calendarFormat: _calendarFormat,
            onFormatChanged: _onFormatChanged,
            enabledDayPredicate: (day) => !_isDateUnavailable(day),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                const Text(
                  'Number of People: ',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 10),
                DropdownButton<int>(
                  value: _numberOfPeople,
                  onChanged: (int? newValue) {
                    setState(() {
                      _numberOfPeople = newValue!;
                    });
                  },
                  items: List.generate(
                    widget.place.maxPeople,
                    (index) => DropdownMenuItem<int>(
                      value: index + 1,
                      child: Text((index + 1).toString()),
                    ),
                  ),
                ),
              ],
            ),
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
