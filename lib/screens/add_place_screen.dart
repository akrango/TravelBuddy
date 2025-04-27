import 'dart:io';
import 'package:airbnb_app/models/category.dart';
import 'package:airbnb_app/providers/host_places_provider.dart';
import 'package:airbnb_app/providers/user_provider.dart';
import 'package:airbnb_app/screens/location_picker_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';

class AddPlaceScreen extends StatefulWidget {
  @override
  _AddPlaceScreenState createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = FirebaseStorage.instance;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _maxPeopleController = TextEditingController();
  final TextEditingController _bedAndBathroomController =
      TextEditingController();

  List<File> _imageFiles = [];
  List<String> _uploadedImageUrls = [];

  final ImagePicker _picker = ImagePicker();

  List<Category> _allCategories = [];
  List<Category> _selectedCategories = [];

  List<String> _amenities = ["WiFi", "Kitchen", "Parking", "TV"];
  List<String> _selectedAmenities = [];
  double? _selectedLatitude;
  double? _selectedLongitude;
  String _selectedAddress = "";
  bool _isUploadingImage = false;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('categories').get();
    List<Category> categories = snapshot.docs
        .map((doc) =>
            (Category.fromMap(doc.data() as Map<String, dynamic>, doc.id)))
        .toList();
    setState(() {
      _allCategories = categories;
    });
  }

  Future<void> _pickImageCamera() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 60);
    if (pickedFile != null) processImage(File(pickedFile.path));
  }

  Future<void> _pickImageGalleryOrDesktop() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null) processImage(File(result.files.single.path!));
  }

  Future<String> uploadBase64Image(File imageFile, String filename) async {
    try {
      final ref = _storage.ref().child('uploads/$filename');
      final bytes = await imageFile.readAsBytes();

      var snapshot = await ref.putData(bytes);

      String url = await snapshot.ref.getDownloadURL();
      return url;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> processImage(File imageFile) async {
    setState(() {
      _imageFiles.add(imageFile);
    });
  }

  Future<void> _savePlace() async {
    if (!_formKey.currentState!.validate()) return;
    if (_imageFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please add at least one image.")));
      return;
    }
    if (_selectedAddress.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please select a location.")));
      return;
    }
    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please select a category.")));
      return;
    }

    setState(() {
      _isUploadingImage = true;
    });

    try {
      _uploadedImageUrls.clear();
      for (var imageFile in _imageFiles) {
        String filename = '${DateTime.now().millisecondsSinceEpoch}.jpg';
        String imageUrl = await uploadBase64Image(imageFile, filename);
        _uploadedImageUrls.add(imageUrl);
      }

      await Provider.of<HostPlacesProvider>(context, listen: false).savePlace(
        title: _titleController.text,
        price: int.parse(_priceController.text),
        address: _selectedAddress,
        description: _descriptionController.text,
        maxPeople: int.parse(_maxPeopleController.text),
        bedAndBathroom: _bedAndBathroomController.text,
        latitude: _selectedLatitude ?? 0.0,
        longitude: _selectedLongitude ?? 0.0,
        imageUrls: _uploadedImageUrls,
        amenities: _selectedAmenities,
        categoryIds: _selectedCategories.map((cat) => cat.id).toList(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Place added successfully!")));

      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await context
          .read<HostPlacesProvider>()
          .fetchHostPlaces(isHost: userProvider.isHost);

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      print("Error saving place: $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error adding place.")));
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add New Place")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: "Title"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter a title" : null),
              TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Price"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter a price" : null),
              TextFormField(
                  controller: _bedAndBathroomController,
                  decoration: InputDecoration(labelText: "Bed & Bath"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter bed & bath details" : null),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: TextEditingController(text: _selectedAddress),
                      decoration: InputDecoration(labelText: "Address"),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.map), onPressed: _openLocationPicker),
                ],
              ),
              TextFormField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: "Description"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter a description" : null),
              TextFormField(
                  controller: _maxPeopleController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Max People"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter max people" : null),
              SizedBox(height: 20),
              DropdownButtonFormField<Category>(
                hint: Text("Select Categories"),
                items: _allCategories.map((category) {
                  return DropdownMenuItem(
                      value: category, child: Text(category.title));
                }).toList(),
                onChanged: (value) {
                  if (!_selectedCategories.contains(value)) {
                    setState(() {
                      _selectedCategories.add(value!);
                    });
                  }
                },
              ),
              Wrap(
                children: _selectedCategories
                    .map((category) => Chip(
                        label: Text(category.title),
                        onDeleted: () => setState(
                            () => _selectedCategories.remove(category))))
                    .toList(),
              ),
              Wrap(
                children: _amenities.map((amenity) {
                  return ChoiceChip(
                    label: Text(amenity),
                    selected: _selectedAmenities.contains(amenity),
                    onSelected: (selected) {
                      setState(() {
                        selected
                            ? _selectedAmenities.add(amenity)
                            : _selectedAmenities.remove(amenity);
                      });
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                      onPressed: _pickImageCamera,
                      icon: Icon(Icons.camera),
                      label: Text("Camera")),
                  ElevatedButton.icon(
                      onPressed: _pickImageGalleryOrDesktop,
                      icon: Icon(Icons.upload_file),
                      label: Text("Pick File")),
                ],
              ),
              Stack(
                children: [
                  Wrap(
                    spacing: 8,
                    children: _imageFiles
                        .map((file) => Image.file(file, width: 80, height: 80))
                        .toList(),
                  ),
                  if (_isUploadingImage)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isUploadingImage ? null : _savePlace,
                child: _isUploadingImage
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Save Place"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openLocationPicker() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerScreen(
          onLocationSelected: (lat, lng, address) {
            setState(() {
              _selectedLatitude = lat;
              _selectedLongitude = lng;
              _selectedAddress = address;
            });
          },
        ),
      ),
    );
  }
}
