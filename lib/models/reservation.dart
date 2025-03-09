import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation {
  final String id;
  final String placeId;
  final String userId;
  final DateTime startDate;
  final DateTime endDate;
  final int numberOfPeople;

  Reservation({
    required this.id,
    required this.placeId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.numberOfPeople,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'placeId': placeId,
      'userId': userId,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'numberOfPeople': numberOfPeople,
    };
  }

  static Reservation fromMap(Map<String, dynamic> map) {
    return Reservation(
      id: map['id'] as String,
      placeId: map['placeId'] as String,
      userId: map['userId'] as String,
      startDate: (map['startDate'] as Timestamp).toDate(),
      endDate: (map['endDate'] as Timestamp).toDate(),
      numberOfPeople: map['numberOfPeople'] as int,
    );
  }
}

final List<Reservation> reservationsList = [
  Reservation(
    id: "r1",
    placeId: "1",
    userId: "u1",
    startDate: DateTime(2025, 3, 15),
    endDate: DateTime(2025, 3, 20),
    numberOfPeople: 2,
  ),
  Reservation(
    id: "r2",
    placeId: "2",
    userId: "u2",
    startDate: DateTime(2025, 4, 5),
    endDate: DateTime(2025, 4, 10),
    numberOfPeople: 1,
  ),
  Reservation(
    id: "r3",
    placeId: "3",
    userId: "u3",
    startDate: DateTime(2025, 6, 10),
    endDate: DateTime(2025, 6, 16),
    numberOfPeople: 4,
  ),
  Reservation(
    id: "r4",
    placeId: "4",
    userId: "u4",
    startDate: DateTime(2025, 12, 20),
    endDate: DateTime(2025, 12, 27),
    numberOfPeople: 6,
  ),
  Reservation(
    id: "r5",
    placeId: "1",
    userId: "u5",
    startDate: DateTime(2025, 3, 18),
    endDate: DateTime(2025, 3, 22),
    numberOfPeople: 3,
  ),
  Reservation(
    id: "r6",
    placeId: "2",
    userId: "u6",
    startDate: DateTime(2025, 4, 1),
    endDate: DateTime(2025, 4, 4),
    numberOfPeople: 2,
  ),
  Reservation(
    id: "r7",
    placeId: "3",
    userId: "u7",
    startDate: DateTime(2025, 6, 12),
    endDate: DateTime(2025, 6, 18),
    numberOfPeople: 2,
  ),
];
