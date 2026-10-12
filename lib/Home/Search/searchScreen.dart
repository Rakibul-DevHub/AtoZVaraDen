import 'dart:convert';
import 'package:flutter/material.dart';
import '../../Rent/rent_details.dart';

class SearchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> listings;

  const SearchScreen({super.key, required this.listings});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = "";
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All",
    "Family Flat",
    "Bachelor / Sublet",
    "Commercial / Office",
    "Hostel",
    "Garage / Parking",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: TextField(
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            hintText: "Search by title, location or category...",
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
        ),
        actions: [
          if (_searchQuery.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  _searchQuery = "";
                });
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: _categories.map((cat) {
                final isSelected = _selectedCategory == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: Colors.teal.shade100,
                    checkmarkColor: Colors.teal,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.teal.shade900 : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? cat : "All";
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          // Results list
          Expanded(child: _buildSearchResults()),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    List<Map<String, dynamic>> filteredListings = widget.listings.where((listing) {
      final title = listing["title"]?.toString().toLowerCase() ?? "";
      final address = listing["address"]?.toString().toLowerCase() ?? "";
      final category = listing["category"]?.toString().toLowerCase() ?? "";
      final query = _searchQuery.toLowerCase();

      final matchesQuery = query.isEmpty ||
          title.contains(query) ||
          address.contains(query) ||
          category.contains(query);

      final matchesCategory = _selectedCategory == "All" ||
          (listing["category"]?.toString() == _selectedCategory);

      return matchesQuery && matchesCategory;
    }).toList();

    if (filteredListings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              "No rentals found matching your query",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: filteredListings.length,
          itemBuilder: (context, index) {
            final data = filteredListings[index];

            // Resolve Image
            ImageProvider? imageProvider;
            final List<dynamic>? networkUrls = data['imageUrls'] as List<dynamic>?;
            final List<dynamic>? imagesList = data['images'] as List<dynamic>?;

            if (networkUrls != null && networkUrls.isNotEmpty) {
              imageProvider = NetworkImage(networkUrls[0] as String);
            } else if (imagesList != null && imagesList.isNotEmpty) {
              final firstImageBase64 = imagesList[0] as String?;
              if (firstImageBase64 != null && firstImageBase64.isNotEmpty) {
                try {
                  imageProvider = MemoryImage(base64Decode(firstImageBase64));
                } catch (_) {}
              }
            }

            final String title = data['title'] ?? 'No Title';
            final double price = double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0;
            final String address = data['address'] ?? 'No Address Provided';
            final String bedroomInfo = data['bedroom'] ?? 'N/A';
            final String bathroomInfo = data['bathroom'] ?? 'N/A';
            final String category = data['category'] ?? 'Rental';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _navigateToDetails(context, data),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Thumbnail
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          width: 110,
                          height: 110,
                          child: imageProvider != null
                              ? Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    color: Colors.grey.shade200,
                                    child: const Icon(Icons.apartment, size: 40, color: Colors.grey),
                                  ),
                                )
                              : Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.apartment, size: 40, color: Colors.grey),
                                ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade50,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    category,
                                    style: TextStyle(
                                      color: Colors.teal.shade800,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  "৳ ${price.toStringAsFixed(0)} / mo",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal.shade700,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    address,
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.bed, size: 14, color: Colors.brown),
                                    const SizedBox(width: 4),
                                    Text(bedroomInfo, style: const TextStyle(fontSize: 12)),
                                    const SizedBox(width: 10),
                                    const Icon(Icons.bathtub_outlined, size: 14, color: Colors.blueGrey),
                                    const SizedBox(width: 4),
                                    Text(bathroomInfo, style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.teal,
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(60, 30),
                                  ),
                                  onPressed: () => _navigateToDetails(context, data),
                                  child: const Text('View Details >'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Map<String, dynamic> data) {
    final List<dynamic>? networkUrls = data['imageUrls'] as List<dynamic>?;
    final List<dynamic>? imagesList = data['images'] as List<dynamic>?;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentDetails(
          title: data['title'] ?? 'No Title',
          description: data['description'] ?? 'No Description',
          price: double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0,
          address: data['address'] ?? 'No Address Provided',
          contactInfo: data['contact_info'] ?? 'No Contact Information',
          bedroom: data['bedroom'] ?? 'N/A',
          bathroom: data['bathroom'] ?? 'N/A',
          imageUrls: networkUrls?.cast<String>(),
          images: imagesList?.cast<String>(),
        ),
      ),
    );
  }
}
