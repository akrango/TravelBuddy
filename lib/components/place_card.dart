import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/providers/category_provider.dart';
import 'package:airbnb_app/providers/favorite_provider.dart';
import 'package:airbnb_app/providers/place_provider.dart';
import 'package:airbnb_app/screens/place_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

class DisplayPlace extends StatelessWidget {
  final int selectedCategoryIndex;
  const DisplayPlace({super.key, required this.selectedCategoryIndex});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final categories = Provider.of<CategoryProvider>(context).categories;
    final selectedCategoryId = categories[selectedCategoryIndex].id;
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final placeProvider = Provider.of<PlaceProvider>(context);
    final places = placeProvider.findByCategory(selectedCategoryId);

    return ListView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: places.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final place = places[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlaceDetailScreen(place: place),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 375,
                        width: double.infinity,
                        child: AnotherCarousel(
                          images: place.imageUrls
                              .map((url) => NetworkImage(url))
                              .toList(),
                          dotSize: 6,
                          indicatorBgPadding: 5,
                          dotBgColor: Colors.transparent,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      left: 15,
                      right: 15,
                      child: Row(
                        children: [
                          place.isActive
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,
                                      vertical: 5,
                                    ),
                                    child: Text(
                                      "GuestFavorite",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(width: size.width * 0.03),
                          const Spacer(),
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
                                  favoriteProvider.toggleFavorite(place);
                                },
                                child: Icon(
                                  Icons.favorite,
                                  size: 30,
                                  color: favoriteProvider.isExist(place)
                                      ? Colors.pinkAccent
                                      : Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    vendorProfile(place),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    Text(
                      place.address,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star),
                    const SizedBox(width: 5),
                    Text(place.rating.toString()),
                  ],
                ),
                Text(
                  "Stay with ${place.vendor} . ${place.vendorProfession}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16.5,
                  ),
                ),
                Text(
                  place.date,
                  style: const TextStyle(
                    fontSize: 16.5,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: size.height * 0.007),
                RichText(
                  text: TextSpan(
                    text: "\$${place.price}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16,
                    ),
                    children: const [
                      TextSpan(
                        text: " night",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.025),
              ],
            ),
          ),
        );
      },
    );
  }

  Positioned vendorProfile(Place place) {
    return Positioned(
      bottom: 11,
      left: 10,
      child: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(place.vendorProfile),
        backgroundColor: Colors.grey[200],
      ),
    );
  }
}
