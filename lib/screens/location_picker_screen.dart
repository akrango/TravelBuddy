import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationPickerScreen extends StatefulWidget {
  final Function(double, double, String) onLocationSelected;

  LocationPickerScreen({required this.onLocationSelected});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String _selectedAddress = "Tap on the map to select a location";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) return;

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _moveCamera(LatLng(position.latitude, position.longitude));
  }

  void _moveCamera(LatLng target) {
    _mapController?.animateCamera(CameraUpdate.newLatLng(target));
    setState(() => _selectedLocation = target);
    _getAddressFromLatLng(target.latitude, target.longitude);
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _selectedAddress =
              "${place.street}, ${place.locality}, ${place.country}";
        });
      }
    } catch (e) {
      print("Error getting address: $e");
    }
  }

  void _onMapTapped(LatLng tappedLocation) {
    _moveCamera(tappedLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pick a Location")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(41.6086, 21.7453),
                zoom: 7.5,
              ),
              onMapCreated: (controller) => _mapController = controller,
              onTap: _onMapTapped,
              markers: _selectedLocation != null
                  ? {
                      Marker(
                          markerId: MarkerId("selected"),
                          position: _selectedLocation!)
                    }
                  : {},
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(_selectedAddress,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_selectedLocation != null) {
                      widget.onLocationSelected(
                        _selectedLocation!.latitude,
                        _selectedLocation!.longitude,
                        _selectedAddress,
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Confirm Location"),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.my_location),
      ),
    );
  }
}
