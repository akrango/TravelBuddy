import 'package:airbnb_app/providers/place_provider.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'dart:typed_data';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng myCurrentLocation = const LatLng(41.6086, 21.7453);
  late GoogleMapController googleMapController;
  final CustomInfoWindowController _customInfoWindowController =
      CustomInfoWindowController();

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadMarkers(context);
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    if (myCurrentLocation.latitude != position.latitude ||
        myCurrentLocation.longitude != position.longitude) {
      setState(() {
        myCurrentLocation = LatLng(position.latitude, position.longitude);
      });

      googleMapController.animateCamera(
        CameraUpdate.newLatLng(myCurrentLocation),
      );
    }
  }

  Future<void> _loadMarkers(BuildContext context) async {
    final placeProvider = Provider.of<PlaceProvider>(context, listen: false);
    final places = placeProvider.places;

    List<Marker> myMarker = [];
    for (final place in places) {
      final data = place.toMap();
      if (data.isNotEmpty) {
        myMarker.add(
          Marker(
            markerId: MarkerId(data['address']),
            position: LatLng(data['latitude'], data['longitude']),
            onTap: () {
              _customInfoWindowController.addInfoWindow!(
                _buildInfoWindow(context, data),
                LatLng(data['latitude'], data['longitude']),
              );
            },
            icon: BitmapDescriptor.defaultMarker,
          ),
        );
      }
    }
    setState(() {
      markers = myMarker;
    });
  }

  Widget _buildInfoWindow(BuildContext context, Map data) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.20,
      width: size.width * 0.8,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              SizedBox(
                height: size.height * 0.203,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    child: AnotherCarousel(
                      images: data['imageUrls']?.map((url) {
                            if (url.startsWith('http')) {
                              return NetworkImage(url);
                            } else {
                              try {
                                final decodedBytes =
                                    base64Decode(url.split(',').last);
                                return MemoryImage(
                                    Uint8List.fromList(decodedBytes));
                              } catch (e) {
                                return const Icon(Icons.broken_image,
                                    color: Colors.red);
                              }
                            }
                          }).toList() ??
                          [],
                      dotSize: 5,
                      indicatorBgPadding: 5,
                      dotBgColor: Colors.transparent,
                    )),
              ),
              Positioned(
                top: 10,
                left: 14,
                right: 14,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        _customInfoWindowController.hideInfoWindow!();
                      },
                      child: const Icon(Icons.close, size: 24),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      data["address"] ??
                          "Address not available",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star),
                    const SizedBox(width: 5),
                    Text(data['rating']?.toString() ??
                        "N/A"),
                  ],
                ),
                Text(
                  data['date'] ??
                      "Date not available",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text:
                        '\$${data['price'] ?? 'N/A'} ',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    children: const [
                      TextSpan(
                        text: "night",
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Map View'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                CameraPosition(target: myCurrentLocation, zoom: 12),
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              _customInfoWindowController.googleMapController = controller;
            },
            onTap: (argument) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _customInfoWindowController.onCameraMove!();
            },
            markers: markers.toSet(),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: size.height * 0.34,
            width: size.width * 0.85,
            offset: 50,
          ),
        ],
      ),
    );
  }
}
