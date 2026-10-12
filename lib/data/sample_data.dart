import 'package:flutter/material.dart';

class ListingModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String bedroom;
  final String bathroom;
  final double price;
  final String address;
  final String contactInfo;
  final List<String> imageUrls;
  final List<String>? base64Images;

  ListingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.bedroom,
    required this.bathroom,
    required this.price,
    required this.address,
    required this.contactInfo,
    required this.imageUrls,
    this.base64Images,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'bedroom': bedroom,
      'bathroom': bathroom,
      'price': price,
      'address': address,
      'contact_info': contactInfo,
      'imageUrls': imageUrls,
      'images': base64Images ?? [],
    };
  }
}

class ListingRepository extends ChangeNotifier {
  static final ListingRepository _instance = ListingRepository._internal();
  factory ListingRepository() => _instance;
  ListingRepository._internal();

  final List<Map<String, dynamic>> _listings = [
    {
      'id': '1',
      'title': 'Luxury 3-Bed Family Apartment in Dhanmondi',
      'description': 'Spacious 1800 sq ft apartment with 3 bedrooms, large living room, modern kitchen, and 3 attached balconies. 24/7 security, lift, and generator backup available.',
      'category': 'Family Flat',
      'bedroom': '3 Beds',
      'bathroom': '3 Baths',
      'price': 38000.0,
      'address': 'Road 27, Dhanmondi, Dhaka',
      'contact_info': '+880 1712-345678',
      'imageUrls': [
        'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=800&auto=format&fit=crop',
      ],
      'images': <String>[],
    },
    {
      'id': '2',
      'title': 'Furnished Bachelor Master Bed with Balcony',
      'description': 'Single master bedroom for executive bachelor in Uttara Sector 11. Attached bath, south-facing balcony, high-speed WiFi, and shared kitchen with cook.',
      'category': 'Bachelor / Sublet',
      'bedroom': '1 Bed',
      'bathroom': '1 Bath',
      'price': 8500.0,
      'address': 'Sector 11, Uttara, Dhaka',
      'contact_info': '+880 1819-876543',
      'imageUrls': [
        'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=800&auto=format&fit=crop',
      ],
      'images': <String>[],
    },
    {
      'id': '3',
      'title': 'Modern Commercial Office Space at Gulshan-1',
      'description': 'Prime commercial 1200 sq ft office space on 5th floor. Fully partitioned with manager rooms, meeting conference room, cafeteria, and basement parking.',
      'category': 'Commercial / Office',
      'bedroom': '4 Rooms',
      'bathroom': '2 Baths',
      'price': 65000.0,
      'address': 'Gulshan Avenue, Gulshan-1, Dhaka',
      'contact_info': '+880 1911-223344',
      'imageUrls': [
        'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1497215728101-856f4ea42174?w=800&auto=format&fit=crop',
      ],
      'images': <String>[],
    },
    {
      'id': '4',
      'title': 'Student Seat in AC Girls Hostel',
      'description': 'Comfortable student hostel bed with three times hygienic meal, study table, 24/7 solar and generator electricity, very close to Dhaka University campus.',
      'category': 'Hostel',
      'bedroom': 'Shared Room',
      'bathroom': 'Shared Bath',
      'price': 6000.0,
      'address': 'Azimpur, Lalbagh, Dhaka',
      'contact_info': '+880 1610-998877',
      'imageUrls': [
        'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=800&auto=format&fit=crop',
      ],
      'images': <String>[],
    },
    {
      'id': '5',
      'title': 'Cozy 2-Bed Flat in Mirpur DOHS',
      'description': 'Peaceful environment in secured Mirpur DOHS community. Natural light in every room, spacious dining, tiled flooring, intercom facility.',
      'category': 'Family Flat',
      'bedroom': '2 Beds',
      'bathroom': '2 Baths',
      'price': 22000.0,
      'address': 'Avenue 4, Mirpur DOHS, Dhaka',
      'contact_info': '+880 1713-445566',
      'imageUrls': [
        'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=800&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=800&auto=format&fit=crop',
      ],
      'images': <String>[],
    },
    {
      'id': '6',
      'title': 'Secure Covered Car Parking Space',
      'description': 'Underground 24/7 CCTV-monitored garage slot available for monthly rent for private sedan or SUV. Gate guard on duty.',
      'category': 'Garage / Parking',
      'bedroom': '1 Bay',
      'bathroom': 'N/A',
      'price': 4000.0,
      'address': 'Banani Block C, Dhaka',
      'contact_info': '+880 1552-334455',
      'imageUrls': [
        'https://images.unsplash.com/photo-1506521781263-d8422e82f27a?w=800&auto=format&fit=crop',
      ],
      'images': <String>[],
    },
  ];

  List<Map<String, dynamic>> get listings => List.unmodifiable(_listings);

  void addListing(Map<String, dynamic> listing) {
    _listings.insert(0, listing);
    notifyListeners();
  }
}
