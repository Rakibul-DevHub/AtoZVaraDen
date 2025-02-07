import 'dart:convert';
import 'package:flutter/material.dart';

import '../../Rent/rent_details.dart';

class SearchScreen extends StatefulWidget {
  final List<Map<String, dynamic>> listings;

  const SearchScreen({Key? key, required this.listings}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade300,
        title: TextField(
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: "Search by title...",
            hintStyle: TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
        ),
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    // Filter listings based on the search query.
    List<Map<String, dynamic>> filteredListings = widget.listings
        .where((listing) => (listing["title"]?.toString().toLowerCase() ?? "")
        .contains(_searchQuery.toLowerCase()))
        .toList();

    if (filteredListings.isEmpty) {
      return const Center(
        child: Text(
          "No results found",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // return ListView.builder(
    //   itemCount: filteredListings.length,
    //   itemBuilder: (context, index) {
    //     final data = filteredListings[index];
    //
    //     // Fetch the images list safely
    //     final List<dynamic>? imagesList = data['images'] as List<dynamic>?;
    //
    //     // Ensure we fetch the first image safely
    //     String? firstImageBase64;
    //     if (imagesList != null && imagesList.isNotEmpty) {
    //       firstImageBase64 = imagesList[0] as String?;
    //     }
    //
    //     final ImageProvider? imageProvider = (firstImageBase64 != null && firstImageBase64.isNotEmpty)
    //         ? MemoryImage(base64Decode(firstImageBase64)) // Decode Base64 to an image
    //         : null;
    //
    //     // Other listing details
    //     final String title = data['title'] ?? 'No Title';
    //     final String description = data['description'] ?? 'No Description';
    //     final double price = double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0;
    //     final String address = data['address'] ?? 'No Address Provided';
    //
    //     return Card(
    //       margin: const EdgeInsets.all(8.0),
    //       child: Padding(
    //         padding: const EdgeInsets.all(8.0),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Row(
    //               children: [
    //                 if (imageProvider != null)
    //                   Image(
    //                     image: imageProvider,
    //                     width: 100,
    //                     height: 100,
    //                     fit: BoxFit.cover,
    //                   )
    //                 else
    //                   Container(
    //                     width: 100,
    //                     height: 100,
    //                     color: Colors.grey[300],
    //                     child: const Icon(Icons.image_not_supported, size: 50),
    //                   ),
    //                 const SizedBox(width: 10),
    //                 Expanded(
    //                   child: Column(
    //                     crossAxisAlignment: CrossAxisAlignment.start,
    //                     children: [
    //                       Text(
    //                         title,
    //                         style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    //                       ),
    //                       const SizedBox(height: 4),
    //                       Text(
    //                         description,
    //                         style: const TextStyle(fontSize: 14),
    //                         maxLines: 2,
    //                         overflow: TextOverflow.ellipsis,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             const SizedBox(height: 10),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 Text(
    //                   "Price: \$${price.toStringAsFixed(2)}",
    //                   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
    //                 ),
    //                 Text(
    //                   address,
    //                   style: const TextStyle(fontSize: 12, color: Colors.grey),
    //                   maxLines: 1,
    //                   overflow: TextOverflow.ellipsis,
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );




    return Center(
      child: SizedBox(
        // width: listViewWidth,
        child: ListView.builder(
          itemCount: filteredListings.length,
          itemBuilder: (context, index) {
            final data = filteredListings[index];

            // Fetch the images list safely
            final List<dynamic>? imagesList = data['images'] as List<dynamic>?;

            // Ensure we fetch the first image safely
            String? firstImageBase64;
            if (imagesList != null && imagesList.isNotEmpty) {
              firstImageBase64 = imagesList[0] as String?;
            }

            final ImageProvider? imageProvider = (firstImageBase64 != null && firstImageBase64.isNotEmpty)
                ? MemoryImage(base64Decode(firstImageBase64)) // Decode Base64 to an image
                : null;

            // Other listing details
            final String title = data['title'] ?? 'No Title';
            final String description = data['description'] ?? 'No Description';
            final double price = double.tryParse(data['price']?.toString() ?? '0.0') ?? 0.0;
            final String address = data['address'] ?? 'No Address Provided';
            final String contactInfo = data['contact_info'] ?? 'No Contact Information';
            final String bedroomInfo = data['bedroom'] ?? 'No Bedroom Information';
            final String bathroomInfo = data['bathroom'] ?? 'No Bathroom Information';

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (imageProvider != null)
                          Image(
                            image: imageProvider,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          )
                        else
                          Container(
                            width: 100,
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported, size: 50),
                          ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                description,
                                style: const TextStyle(fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Price: \$${price.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          address,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RentDetails(
                              title: title,
                              description: description,
                              images: imagesList?.cast<String>(),
                              price: price,
                              address: address,
                              contactInfo: contactInfo,
                              bedroom: bedroomInfo,
                              bathroom: bathroomInfo,
                            ),
                          ),
                        ),
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );




  }
}
