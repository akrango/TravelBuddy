import 'package:airbnb_app/components/favorite_place_card.dart';
import 'package:airbnb_app/providers/favorite_provider.dart';
import 'package:airbnb_app/providers/place_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  bool isBase64(String imageString) {
    return imageString.startsWith('data:image');
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PlaceProvider>(context);
    final favoriteIds = Provider.of<FavoriteProvider>(context).favorites;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 35),
                const Text(
                  "Favorites",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 5),
                favoriteIds.isEmpty
                    ? const Text(
                        "No Favorite items yet",
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: favoriteIds.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                          String favoriteId = favoriteIds[index];
                          return FavoritePlaceCard(favoriteId: favoriteId);
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
