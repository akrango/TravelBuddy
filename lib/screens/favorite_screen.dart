import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/providers/favorite_provider.dart';
import 'package:airbnb_app/providers/place_provider.dart';
import 'package:airbnb_app/screens/place_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

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
                          return FutureBuilder<Place?>(
                              future: provider.findById(favoriteId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                                if (snapshot.hasError || !snapshot.hasData) {
                                  return const Center(
                                      child:
                                          Text("Error loading place details"));
                                }
                                Place? place = snapshot.data;
                                if (place == null) {
                                  return const Center(
                                      child: Text(
                                          "There are no favorite places yet"));
                                }
                                return Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(place.image),
                                        ),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  PlaceDetailScreen(
                                                      place: place),
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
                                              Provider.of<FavoriteProvider>(
                                                      context,
                                                      listen: false)
                                                  .toggleFavorite(place);
                                            },
                                            child: Icon(
                                              Icons.favorite,
                                              size: 26,
                                              color:
                                                  Provider.of<FavoriteProvider>(
                                                              context,
                                                              listen: false)
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
                                        color:
                                            Colors.deepPurple.withOpacity(0.6),
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
                              });
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
