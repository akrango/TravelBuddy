import 'dart:convert';
import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/providers/favorite_provider.dart';
import 'package:airbnb_app/providers/place_provider.dart';
import 'package:airbnb_app/screens/place_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePlaceCard extends StatelessWidget {
  final String favoriteId;

  const FavoritePlaceCard({Key? key, required this.favoriteId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);

    return FutureBuilder<Place?>(
      future: placeProvider.findById(favoriteId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Error loading place details"));
        }
        final place = snapshot.data;
        if (place == null) {
          return const Center(child: Text("Place not found"));
        }

        ImageProvider imageProvider;
        if (place.image.startsWith('http')) {
          imageProvider = CachedNetworkImageProvider(place.image);
        } else {
          try {
            final base64String = place.image.split(',').last;
            final bytes = base64Decode(base64String);
            imageProvider = MemoryImage(bytes);
          } catch (e) {
            return const Icon(Icons.broken_image, color: Colors.red);
          }
        }

        return Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlaceDetailScreen(place: place),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.favorite_outline_rounded,
                    size: 30,
                    color: Colors.white,
                  ),
                  InkWell(
                    onTap: () {
                      Provider.of<FavoriteProvider>(context, listen: false)
                          .toggleFavorite(place);
                    },
                    child: Icon(
                      Icons.favorite,
                      size: 26,
                      color:
                          Provider.of<FavoriteProvider>(context, listen: false)
                                  .isExist(place)
                              ? Colors.pinkAccent
                              : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Container(
                color: Colors.deepPurple.withOpacity(0.6),
                padding: const EdgeInsets.all(4),
                child: Text(
                  place.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
