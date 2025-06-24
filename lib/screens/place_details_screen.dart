import 'dart:convert';
import 'package:airbnb_app/components/review_card.dart';
import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/models/review.dart';
import 'package:airbnb_app/models/user.dart';
import 'package:airbnb_app/providers/user_provider.dart';
import 'package:airbnb_app/services/review_service.dart';
import 'package:airbnb_app/providers/favorite_provider.dart';
import 'package:airbnb_app/screens/reservation_screen.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatefulWidget {
  final Place place;
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  int currentIndex = 0;
  GoogleMapController? _mapController;
  late LatLng _location;
  double averageRating = 0.0;
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    _location = LatLng(widget.place.latitude, widget.place.longitude);
    _loadPlaceData();
  }

  Future<void> _loadPlaceData() async {
    final reviewService = ReviewService();

    double avgRating =
        await reviewService.getAverageRatingForPlace(widget.place.id);
    List<Review> placeReviews =
        await reviewService.getReviewsForPlace(widget.place.id);

    setState(() {
      averageRating = avgRating;
      reviews = placeReviews;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserProvider>(context).user;
    Size size = MediaQuery.of(context).size;
    final provider = FavoriteProvider.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailImageandIcon(size, context, provider),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.place.title,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 25,
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),
                  Text(
                    "Room in ${widget.place.address}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    widget.place.bedAndBathroom,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            ratingAndStar(),
            SizedBox(height: size.height * 0.02),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(),
                  placePropertyList(
                    size,
                    widget.place.vendorProfile,
                    "Stay with ${widget.place.vendor}",
                    "Superhost . ${user?.yearsOfHosting ?? 0} years hosting",
                  ),
                  const Divider(),
                  amenitiesList(size),
                  const Divider(),
                  SizedBox(height: size.height * 0.02),
                  const Text(
                    "About this place",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  Text(
                    widget.place.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const Divider(),
                  const Text(
                    "Where  you'll be",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.place.address,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(
                    height: 300,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _location,
                        zoom: 14.0,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId("placeMarker"),
                          position: _location,
                          infoWindow: InfoWindow(
                            title: widget.place.title,
                          ),
                        ),
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            const Divider(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text(
                "Reviews",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (reviews.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Text("No reviews yet. Be the first to leave a review."),
              )
            else
              Column(
                children: reviews.map((review) {
                  return ReviewCard(
                    userId: review.userId,
                    createdAt: review.createdAt,
                    rating: review.rating,
                    reviewText: review.reviewText,
                  );
                }).toList(),
              ),
            SizedBox(height: 100),
          ],
        ),
      ),
      bottomSheet: priceAndReserve(size),
    );
  }

  Container priceAndReserve(Size size) {
    return Container(
      height: size.height * 0.1,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                text: TextSpan(
                  text: "\$${widget.place.price} ",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 18,
                  ),
                  children: const [
                    TextSpan(
                      text: "night",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (widget.place.vendor !=
              FirebaseAuth.instance.currentUser?.displayName) ...[
            SizedBox(
              width: size.width * 0.3,
            ),
            GestureDetector(
              onTap: () => _navigateToDateSelection(context, widget.place),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(15)),
                child: const Text(
                  "Reserve",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  void _navigateToDateSelection(BuildContext context, Place place) async {
    final selectedDates = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReservationScreen(
          place: place,
        ),
      ),
    );

    if (selectedDates != null) {
      print('Selected Start: ${selectedDates['startDate']}');
      print('Selected End: ${selectedDates['endDate']}');
    }
  }

  Padding placePropertyList(
      Size size, String image, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: CachedNetworkImageProvider(image),
            radius: 29,
          ),
          SizedBox(width: size.width * 0.05),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: size.width * 0.0346,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding amenitiesList(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var amenity in widget.place.amenities)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: Text(
                    amenity,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Padding ratingAndStar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star),
          const SizedBox(width: 5),
          Text(
            "${averageRating.toStringAsFixed(1)} . ",
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "${reviews.length} reviews",
            style: const TextStyle(
              fontSize: 17,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Stack detailImageandIcon(Size size, BuildContext context, provider) {
    return Stack(
      children: [
        SizedBox(
          height: size.height * 0.35,
          child: AnotherCarousel(
            images: widget.place.imageUrls.map((url) {
              if (url.startsWith('http')) {
                return CachedNetworkImage(
                  imageUrl: url,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image, color: Colors.red),
                  fit: BoxFit.cover,
                );
              } else {
                try {
                  final base64String = url.split(',').last;
                  final bytes = base64Decode(base64String);
                  return Image.memory(
                    bytes,
                    fit: BoxFit.cover,
                  );
                } catch (e) {
                  return const Icon(Icons.broken_image, color: Colors.red);
                }
              }
            }).toList(),
            showIndicator: false,
            dotBgColor: Colors.transparent,
            onImageChange: (p0, p1) {
              setState(() {
                currentIndex = p1;
              });
            },
            autoplay: true,
            boxFit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 10,
          right: 20,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 5,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.black45),
            child: Text(
              "${currentIndex + 1} / ${widget.place.imageUrls.length}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          left: 0,
          top: 25,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                  ),
                ),
                SizedBox(
                  width: size.width * 0.55,
                ),
                const SizedBox(width: 60),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(
                      Icons.favorite_outline_rounded,
                      size: 34,
                      color: Colors.white,
                    ),
                    InkWell(
                      onTap: () {
                        provider.toggleFavorite(widget.place);
                      },
                      child: Icon(
                        Icons.favorite,
                        size: 30,
                        color: provider.isExist(widget.place)
                            ? Colors.pinkAccent
                            : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
