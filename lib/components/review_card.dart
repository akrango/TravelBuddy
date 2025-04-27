import 'package:airbnb_app/services/review_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReviewCard extends StatefulWidget {
  final String userId;
  final int rating;
  final String reviewText;
  final DateTime createdAt;

  const ReviewCard({
    Key? key,
    required this.userId,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
  }) : super(key: key);

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  String? reviewerName;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchReviewerName();
  }

  Future<void> fetchReviewerName() async {
    final reviewService = ReviewService();

    String name = await reviewService.fetchReviewerName(widget.userId);
    setState(() {
      reviewerName = name;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('MMM dd, yyyy').format(widget.createdAt);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          reviewerName ?? 'Unknown User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                ),
                const SizedBox(width: 10),
                Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 5),
                Text(
                  widget.rating.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              widget.reviewText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
