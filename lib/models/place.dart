import 'package:airbnb_app/models/reservation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Place {
  final String id;
  final String title;
  bool isActive;
  final String image;
  final double rating;
  final int price;
  final String address;
  final String vendor;
  final String vendorProfession;
  final String vendorProfile;
  final int review;
  final String bedAndBathroom;
  final int yearOfHosting;
  final double latitude;
  final double longitude;
  final List<String> imageUrls;
  final String description;
  final int maxPeople;
  final String hostId;
  final List<String> amenities;
  final List<String> categories;
  final List<Reservation> reservations;

  Place({
    required this.id,
    required this.title,
    required this.isActive,
    required this.image,
    required this.rating,
    required this.price,
    required this.address,
    required this.vendor,
    required this.vendorProfession,
    required this.vendorProfile,
    required this.review,
    required this.bedAndBathroom,
    required this.yearOfHosting,
    required this.latitude,
    required this.longitude,
    required this.imageUrls,
    required this.description,
    required this.maxPeople,
    required this.hostId,
    required this.amenities,
    required this.categories,
    this.reservations = const [],
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'isActive': isActive,
      'image': image,
      'rating': rating,
      'price': price,
      'address': address,
      'vendor': vendor,
      'vendorProfession': vendorProfession,
      'vendorProfile': vendorProfile,
      'review': review,
      'bedAndBathroom': bedAndBathroom,
      'yearOfHosting': yearOfHosting,
      'latitude': latitude,
      'longitude': longitude,
      'imageUrls': imageUrls,
      'description': description,
      'maxPeople': maxPeople,
      'amenities': amenities,
      'categories': categories,
    };
  }

  static Future<Place> fromMap(
      Map<String, dynamic> data, String documentId) async {
    return Place(
      id: documentId,
      title: data['title'] ?? '',
      isActive: data['isActive'] ?? false,
      image: data['image'] ?? '',
      rating: data['rating']?.toDouble() ?? 0.0,
      price: data['price'] ?? 0,    
      address: data['address'] ?? '',
      vendor: data['vendor'] ?? '',
      vendorProfession: data['vendorProfession'] ?? '',
      vendorProfile: data['vendorProfile'] ?? '',
      review: data['review'] ?? 0,
      bedAndBathroom: data['bedAndBathroom'] ?? '',
      yearOfHosting: data['yearOfHosting'] ?? 0,
      latitude: data['latitude']?.toDouble() ?? 0.0,
      longitude: data['longitude']?.toDouble() ?? 0.0,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      description: data['description'] ?? '',
      maxPeople: data['maxPeople'] ?? 0,
      hostId: data['hostId'] ?? '',
      amenities: List<String>.from(data['amenities'] ?? []),
      categories: List<String>.from(data['categories'] ?? []),
      reservations: (data['reservations'] as List<dynamic>?)
              ?.map((e) => Reservation.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

Future<void> savePlacesToFirebase() async {
  final CollectionReference ref =
      FirebaseFirestore.instance.collection("places");

  for (var place in listOfPlaces) {
    ref.doc("das");
    await ref.add(place.toMap());
  }
}

final List<Place> listOfPlaces = [
  Place(
    id: "1",
    hostId: "u1",
    isActive: true,
    title: "Charming Cottage in Serene Countryside",
    image:
        "https://www.vertuliving.com/cdn/shop/articles/935082_Cropped.jpg?v=1720694833&width=1500",
    rating: 4.72,
    review: 89,
    bedAndBathroom: "2 beds · Private bathroom",
    price: 50,
    address: "Devon, England",
    vendor: "Eleanor",
    vendorProfession: "Landscape Designer",
    yearOfHosting: 7,
    vendorProfile:
        "https://newsroom.unsw.edu.au/sites/default/files/styles/full_width__2x/public/thumbnails/image/closeup_of_woman_smiling_while_taking_a_selfie_in_her_living_room_1.jpeg",
    latitude: 50.7155,
    longitude: -3.5309,
    imageUrls: [
      "https://www.vertuliving.com/cdn/shop/articles/935082_Cropped.jpg?v=1720694833&width=1500",
      "https://edwardgeorgelondon.com/wp-content/uploads/content/a_warm_and_inviting_modern_cottage_living_room_with_rustic_charm_soft_colors_comfortable_furniture_and_natural_textures2.png",
    ],
    description: "Enjoy a peaceful stay in this charming countryside retreat.",
    maxPeople: 4,
    amenities: [
      "Wifi",
      "Fireplace",
      "Pet-friendly",
      "Kitchen",
      "Private garden",
      "Free parking",
      "BBQ grill",
      "Heating",
    ],
    categories: ["1", "4", "7"], // Rooms, Mountains, and Design
  ),
  Place(
    id: "2",
    hostId: "u2",
    isActive: false,
    title: "Modern Studio in the Heart of the City",
    image:
        "https://cf.bstatic.com/xdata/images/hotel/max1024x768/151199952.jpg?k=b3de0ed370fed0d4702957e03ee44fd9137b3450cea1a5540a7c86d65245a742&o=&hp=1",
    rating: 4.85,
    review: 215,
    bedAndBathroom: "1 bed · Ensuite bathroom",
    price: 75,
    address: "Chicago, USA",
    vendor: "Damien",
    vendorProfession: "Architect",
    yearOfHosting: 5,
    vendorProfile:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSs3bBJwclAtu9VTthg-MiGdya8x9Xb9JIoLw&s",
    latitude: 41.8781,
    longitude: -87.6298,
    imageUrls: [
      "https://cf.bstatic.com/xdata/images/hotel/max1024x768/151199952.jpg?k=b3de0ed370fed0d4702957e03ee44fd9137b3450cea1a5540a7c86d65245a742&o=&hp=1",
      "https://cf.bstatic.com/xdata/images/hotel/max1024x768/151199749.jpg?k=9e568e186643dbc21ab6b9a5ed4ae910d574fa31dee84977156d90b7429272b2&o=&hp=1",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSRAgRzCHWWc9bhxySyUM3XTQkLrEJJ0vgvgw&s",
    ],
    description:
        "This sleek studio apartment offers city views and modern comforts.",
    maxPeople: 2,
    amenities: [
      "Wifi",
      "Smart TV",
      "Air conditioning",
      "Kitchen",
      "Coffee maker",
      "Dedicated workspace",
      "Elevator",
      "24-hour security",
    ],
    categories: ["1", "6"], // Rooms, New
  ),
  Place(
    id: "3",
    hostId: "u3",
    isActive: true,
    title: "Beachside Bungalow with Ocean Views",
    image:
        "https://a0.muscache.com/im/pictures/miso/Hosting-1027670816422613042/original/a03a8931-a429-47b1-997a-cfbb17d6cb53.jpeg?im_w=720&im_format=avif",
    rating: 4.90,
    review: 320,
    bedAndBathroom: "3 beds · 2 bathrooms",
    price: 120,
    address: "Maui, Hawaii",
    vendor: "Lila",
    vendorProfession: "Photographer",
    yearOfHosting: 12,
    vendorProfile:
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQAq8K_slWr1zHjiZxMcV27qANo8OqxZmeCTA&s",
    latitude: 20.7984,
    longitude: -156.3319,
    imageUrls: [
      "https://a0.muscache.com/im/pictures/miso/Hosting-1027670816422613042/original/a03a8931-a429-47b1-997a-cfbb17d6cb53.jpeg?im_w=720&im_format=avif",
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR6Inkt4D1HXvJZ6S_4_PIp3_WvzPn_pjlSiw&s",
      "https://img.trackhs.com/x300/https://track-pm.s3.amazonaws.com/sbvacationrentals/image/a8ba738b-4904-4cef-ad7d-0f6cfe14032b",
      "https://i.pinimg.com/736x/54/d6/2d/54d62dae2aa3b91fbbb7a4c7f341d84d.jpg",
    ],
    description: "Relax in this stunning bungalow just steps from the beach.",
    maxPeople: 6,
    amenities: [
      "Wifi",
      "Oceanfront patio",
      "Snorkeling gear",
      "Kitchen",
      "Private parking",
      "BBQ grill",
      "Outdoor shower",
      "Air conditioning",
    ],
    categories: ["2", "5"], // Beach, Ocean
  ),
  Place(
    id: "4",
    hostId: "u4",
    isActive: true,
    title: "Mountain Chalet with Stunning Views",
    image:
        "https://www.alpsinluxury.com/blog/wp-content/uploads/2021/02/Image00035.jpg",
    rating: 4.67,
    review: 180,
    bedAndBathroom: "4 beds · 3 bathrooms",
    price: 200,
    address: "Aspen, USA",
    vendor: "Jonas",
    vendorProfession: "Ski Instructor",
    yearOfHosting: 9,
    vendorProfile:
        "https://hosttools.com/wp-content/uploads/ben-den-engelsen-YUu9UAcOKZ4-unsplash.jpg.webp",
    latitude: 39.1911,
    longitude: -106.8175,
    imageUrls: [
      "https://www.alpsinluxury.com/blog/wp-content/uploads/2021/02/Image00035.jpg",
      "https://img.freepik.com/premium-photo/luxury-mountain-chalet-with-stunning-view_332713-24337.jpg",
    ],
    description: "Escape to this luxurious chalet nestled in the mountains.",
    maxPeople: 8,
    amenities: [
      "Wifi",
      "Hot tub",
      "Fireplace",
      "Ski-in/ski-out access",
      "Game room",
      "Private chef available",
      "Heating",
    ],
    categories: ["4", "2"], // Mountains, Luxury
  ),
];
