import 'package:airbnb_app/models/place.dart';
import 'package:airbnb_app/providers/host_places_provider.dart';
import 'package:airbnb_app/providers/user_provider.dart';
import 'package:airbnb_app/screens/add_place_screen.dart';
import 'package:airbnb_app/screens/place_details_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HostDashboardScreen extends StatelessWidget {
  const HostDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Places"),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: Provider.of<HostPlacesProvider>(context, listen: false).fetchHostPlaces(isHost: userProvider.isHost),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            
            final hostProvider = Provider.of<HostPlacesProvider>(context);
            
            return hostProvider.hostPlaces.isEmpty
                ? const Center(child: Text("You don't have any places yet"))
                : ListView.builder(
                    itemCount: hostProvider.hostPlaces.length,
                    itemBuilder: (context, index) {
                      final place = hostProvider.hostPlaces[index];
                      return _buildPlaceCard(context, place);
                    },
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPlaceScreen(),
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context, Place place) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
           imageUrl: place.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(place.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("\$${place.price} per night • ${place.review} reviews"),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlaceDetailScreen(place: place),
            ),
          );
        },
      ),
    );
  }

}